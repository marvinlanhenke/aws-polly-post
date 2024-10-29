provider "aws" {
  region = "eu-central-1"
}

resource "aws_dynamodb_table" "posts" {
  name           = "posts"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_s3_bucket" "aws-polly-post-audiofiles" {
  bucket = "aws-polly-post-audiofiles"
}

resource "aws_sns_topic" "new_posts" {
  name         = "new_posts"
  display_name = "New Posts"
}
