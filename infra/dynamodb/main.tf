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