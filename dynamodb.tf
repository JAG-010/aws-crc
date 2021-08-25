resource "aws_dynamodb_table" "crc-dynamodb-table" {
  name           = "crc-table"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "visitor_num"


  attribute {
    name = "visitor_num"
    type = "N"
  }

 
  tags = local.tags
}