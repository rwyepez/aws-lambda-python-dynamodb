module "dynamodb" {
  source = "./dynamodb"
}

module "policies" {
  source             = "./policies"
  dynamodb_table_arn = module.dynamodb.dynamodb_table_arn
}

module "lambda" {
  source                       = "./lambdas"
  lambda_logging_policy_arn    = module.policies.lambda_logging_policy_arn
  aws_iam_policy_document_json = module.policies.aws_iam_policy_document_json
  dynamodb_table_name          = module.dynamodb.dynamodb_table_name
  policy_query_dynamodb_arn    = module.policies.policy_query_dynamodb_arn
}

module "apigw" {
  source                   = "./apigw"
  car_lambda_function_arn  = module.lambda.car_lambda_function_arn
  car_lambda_function_name = module.lambda.car_lambda_function_name
}
