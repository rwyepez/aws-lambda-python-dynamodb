output "car_lambda_function_arn" {
  value = aws_lambda_function.car_lambda_function.invoke_arn
}

output "car_lambda_function_name" {
  value = aws_lambda_function.car_lambda_function.function_name
}
