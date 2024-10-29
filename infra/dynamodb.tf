resource "aws_dynamodb_table" "aws_polly_post_posts" {
  name           = "aws-polly-post-posts"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
