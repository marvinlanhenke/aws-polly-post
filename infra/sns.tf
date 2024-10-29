resource "aws_sns_topic" "aws_polly_post_new_posts" {
  name         = "aws-polly-post-new-posts"
  display_name = "AWS-Polly-Post New Posts"
}

resource "aws_sns_topic_subscription" "new_posts_subscription" {
  topic_arn = aws_sns_topic.aws_polly_post_new_posts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.convert_to_audio.arn
}
