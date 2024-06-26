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
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.car_resource.id
  http_method             = aws_api_gateway_method.car_post_method.http_method
  type                    = "AWS_PROXY"
  uri                     = var.car_lambda_function_arn
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
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.car_resource.id
  http_method             = aws_api_gateway_method.car_get_method.http_method
  type                    = "AWS_PROXY"
  uri                     = var.car_lambda_function_arn
  integration_http_method = "POST"
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
  function_name = var.car_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*/*"
}