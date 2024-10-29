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

data "archive_file" "archive_convert_to_audio" {
  type        = "zip"
  source_file = "${path.module}/../server/convert_to_audio.py"
  output_path = "${path.module}/../server/build/convert_to_audio.zip"
}

resource "aws_lambda_function" "convert_to_audio" {
  filename         = "${path.module}/../server/build/convert_to_audio.zip"
  function_name    = "convert_to_audio"
  role             = aws_iam_role.iam_for_lamba.arn
  source_code_hash = data.archive_file.archive_convert_to_audio.output_base64sha256
  runtime          = "python3.12"
  handler          = "convert_to_audio.lambda_handler"

  environment {
    variables = {
      BUCKET_NAME   = "${aws_s3_bucket.aws_polly_post_audiofiles.bucket}"
      DB_TABLE_NAME = "${aws_dynamodb_table.aws_polly_post_posts.arn}"
    }
  }
}

resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.convert_to_audio.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.aws_polly_post_new_posts.arn
}

resource "null_resource" "sam_metadata_aws_lambda_function_convert_to_audio" {
  triggers = {
    resource_name        = "aws_lambda_function.convert_to_audio"
    resource_type        = "ZIP_LAMBDA_FUNCTION"
    original_source_code = "${path.module}/../server"
    built_output_path    = "${path.module}/../server/build/convert_to_audio.zip"
  }
}
