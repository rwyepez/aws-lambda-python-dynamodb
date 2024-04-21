# Table to store data
resource "aws_dynamodb_table" "my_table" {
  name           = "my_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "carId"
  range_key      = "model"

  attribute {
    name = "carId"
    type = "S"
  }

  attribute {
    name = "model"
    type = "S"
  }
}

# LAMBDAS POLICIES
# Default lambda policy
data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

# Logging policy for lambdas
resource "aws_iam_policy" "lambda_logging_policy" {
  name        = "lambda_logging_policy"
  path        = "/"
  description = "IAM policy for logging lambdas"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*",
        "Effect" : "Allow"
      }
    ]
  })
}

# Policy with permissions to query in DynamoDB
resource "aws_iam_policy" "policy_query_dynamodb" {
  name        = "policy_query_dynamodb"
  path        = "/"
  description = "Permissions to query in dynamodb"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action": [
            "dynamodb:Query",
            "dynamodb:PutItem"
        ],
        "Resource" : aws_dynamodb_table.my_table.arn
      }
    ]
  })
}

# Role for lambda
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

# Attach permissions for lambda role
# Attach ExecutionRole
resource "aws_iam_role_policy_attachment" "lambda_basic_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Attach logging policy
resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attach" {
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
  role       = aws_iam_role.lambda_role.name
}
# Attach query dynamo policy 
resource "aws_iam_role_policy_attachment" "lambda_query_dynamo" {
  policy_arn = aws_iam_policy.policy_query_dynamodb.arn
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
      DYNAMODB_TABLE = aws_dynamodb_table.my_table.name
    }
  }
}
#Cloudwatch log group to list created images role
resource "aws_cloudwatch_log_group" "car_lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.car_lambda_function.function_name}"
  retention_in_days = 1
}