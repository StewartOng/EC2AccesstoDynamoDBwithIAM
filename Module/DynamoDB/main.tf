resource "aws_dynamodb_table" "bookinventory" {
  name           = "${var.prefix}-bookinventory"
  billing_mode   = "PAY_PER_REQUEST" # On-demand billing
  hash_key       = "ISBN" # Partition Key
  range_key      = "Genre" # Sort Key

  attribute {
    name = "ISBN" 
    type = "S" # String
  }
  attribute {
    name = "Genre"
    type = "S" # String
  }



  tags = {
    Environment = "Dev"
    Application = "BookInventory"
    CreatedBy   = var.createdByTerraform
  }
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.bookinventory.arn
}
output "dynamodb_table_name" {
  value = aws_dynamodb_table.bookinventory.name
}