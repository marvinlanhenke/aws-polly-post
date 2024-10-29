provider "aws" {
  region = "eu-central-1"
}

resource "aws_dynamodb_table" "aws-polly-post-posts" {
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

resource "aws_s3_bucket" "aws-polly-post-audiofiles" {
  bucket = "aws-polly-post-audiofiles"
}

resource "aws_sns_topic" "aws-polly-post-new_posts" {
  name         = "aws-polly-post-new-posts"
  display_name = "AWS-Polly-Post New Posts"
}
