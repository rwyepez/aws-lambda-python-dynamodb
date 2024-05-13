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
        "Resource" : var.dynamodb_table_arn
      }
    ]
  })
}