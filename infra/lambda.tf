resource "aws_cloudwatch_log_group" "log_group_new_posts" {
  name              = "/aws/lambda/${aws_lambda_function.new_posts.function_name}"
  retention_in_days = 1
}

data "archive_file" "archive_new_posts" {
  type        = "zip"
  source_file = "${path.module}/../server/new_posts.py"
  output_path = "${path.module}/../server/build/new_posts.zip"
}

resource "aws_lambda_function" "new_posts" {
  filename         = "${path.module}/../server/build/new_posts.zip"
  function_name    = "new_posts"
  role             = aws_iam_role.iam_for_lamba.arn
  source_code_hash = data.archive_file.archive_new_posts.output_base64sha256
  runtime          = "python3.12"
  handler          = "new_posts.lambda_handler"

  environment {
    variables = {
      SNS_TOPIC_ARN = "${aws_sns_topic.aws_polly_post_new_posts.arn}"
      DB_TABLE_NAME = "${aws_dynamodb_table.aws_polly_post_posts.arn}"
    }
  }
}

resource "null_resource" "sam_metadata_aws_lambda_function_new_posts" {
  triggers = {
    resource_name        = "aws_lambda_function.new_posts"
    resource_type        = "ZIP_LAMBDA_FUNCTION"
    original_source_code = "${path.module}/../server"
    built_output_path    = "${path.module}/../server/build/new_posts.zip"
  }
}
