resource "aws_dynamodb_table" "crc-dynamodb-table" {
  name           = "crc-table"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ID"


  attribute {
    name = "ID"
    type = "N"
  }

  attribute {
    name = "count"
    type = "N"
  }

  tags = local.tags
}