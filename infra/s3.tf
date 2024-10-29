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

resource "aws_s3_bucket" "aws_polly_post_website" {
  bucket        = "aws-polly-post-website"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "aws_polly_post_website_public_access" {
  bucket = aws_s3_bucket.aws_polly_post_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "aws_polly_post_website_configuration" {
  bucket = aws_s3_bucket.aws_polly_post_website.id
  index_document {
    suffix = "index.html"
  }
}

data "aws_iam_policy_document" "audiofiles_public_read_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.aws_polly_post_audiofiles.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "aws_polly_post_audiofiles_policy" {
  bucket = aws_s3_bucket.aws_polly_post_audiofiles.id
  policy = data.aws_iam_policy_document.audiofiles_public_read_policy_document.json
}

data "aws_iam_policy_document" "website_public_read_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.aws_polly_post_website.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "aws_polly_post_website_policy" {
  bucket = aws_s3_bucket.aws_polly_post_website.id
  policy = data.aws_iam_policy_document.website_public_read_policy_document.json
}
