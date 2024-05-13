output "lambda_logging_policy_arn" {
    value = aws_iam_policy.lambda_logging_policy.arn
}

output "policy_query_dynamodb_arn" {
    value = aws_iam_policy.policy_query_dynamodb.arn
}
