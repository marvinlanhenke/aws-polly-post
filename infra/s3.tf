resource "aws_s3_bucket" "aws_polly_post_audiofiles" {
  bucket        = "aws-polly-post-audiofiles"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "aws_polly_post_audiofile_public_access" {
  bucket = aws_s3_bucket.aws_polly_post_audiofiles.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "aws_polly_post_public_read_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.aws_polly_post_audiofiles.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "aws_polly_post_bucket_policy" {
  bucket = aws_s3_bucket.aws_polly_post_audiofiles.id
  policy = data.aws_iam_policy_document.aws_polly_post_public_read_policy_document.json
}
