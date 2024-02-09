# DynamoDB Table
resource "aws_dynamodb_table" "my_dynamodb_table" {
  name           = "myTable"
  billing_mode   = "PAY_PER_REQUEST"  # Use PAY_PER_REQUEST or PROVISIONED based on your needs
  hash_key       = "id"
  stream_enabled = false  # Set to true if you want to enable DynamoDB Streams
  stream_view_type = "NEW_IMAGE"  # Choose the stream view type

  attribute {
    name = "id"
    type = "S"  # Assuming 'id' is a string, adjust the type accordingly
  }

  # Additional table settings if needed

  tags = {
    Name = "MyDynamoDBTable"
  }
}
