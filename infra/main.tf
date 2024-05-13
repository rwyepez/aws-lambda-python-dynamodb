module "dynamodb" {
  source = "./dynamodb"
}

module "policies" {
  source = "./policies"
  dynamodb_table_arn = module.dynamodb.dynamodb_table_arn
}

# Role for lambda
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = module.policies.aws_iam_policy_document_json
}

# Attach permissions for lambda role
# Attach ExecutionRole
resource "aws_iam_role_policy_attachment" "lambda_basic_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Attach logging policy
resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attach" {
  policy_arn = module.policies.lambda_logging_policy_arn
  role       = aws_iam_role.lambda_role.name
}
# Attach query dynamo policy 
resource "aws_iam_role_policy_attachment" "lambda_query_dynamo" {
  policy_arn = module.policies.policy_query_dynamodb_arn
  role       = aws_iam_role.lambda_role.name
}


#----- Lambda resource
#Create zip file with code to upload lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../code/cars/lambda_function.py"
  output_path = "${path.module}/lambda.zip"
}
#Lambda function
resource "aws_lambda_function" "car_lambda_function" {
  function_name    = "car_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  filename         = data.archive_file.lambda_zip.output_path
  timeout          = 30
  environment {
    variables = {      
      DYNAMODB_TABLE = module.dynamodb.dynamodb_table_name
    }
  }
}
#Cloudwatch log group to list created images role
resource "aws_cloudwatch_log_group" "car_lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.car_lambda_function.function_name}"
  retention_in_days = 1
}


resource "aws_api_gateway_rest_api" "my_api" {
  name        = "CarAPI"
  description = "API to manage cars data"
}

resource "aws_api_gateway_resource" "car_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "cars"
}

resource "aws_api_gateway_method" "car_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.car_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.car_resource.id
  http_method = aws_api_gateway_method.car_post_method.http_method
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.car_lambda_function.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_method" "car_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.car_resource.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.carId" = true
  }
}

resource "aws_api_gateway_integration" "lambda_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.car_resource.id
  http_method = aws_api_gateway_method.car_get_method.http_method
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.car_lambda_function.invoke_arn
  integration_http_method = "GET"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_get_integration,
    aws_api_gateway_integration.lambda_post_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "dev"
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.car_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*/*"
}
