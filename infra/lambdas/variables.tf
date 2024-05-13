variable "lambda_logging_policy_arn" {
  type        = string
  description = "lambda logging policy arn"
}

variable "aws_iam_policy_document_json" {
  type        = string
  description = "policy json"
}

variable "dynamodb_table_name" {
  type        = string
  description = "dynamo table name"
}

variable "policy_query_dynamodb_arn" {
  type        = string
  description = "policy dynamodb arn"
}
