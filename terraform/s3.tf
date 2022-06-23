locals {
  front_bucket_name = "${var.app_name}-${var.app_env}-front"
}

resource "aws_s3_bucket" "front" {
  bucket        = local.front_bucket_name
  force_destroy = true

  tags = {
    Name        = local.front_bucket_name
    Environment = var.app_env
  }
}

resource "aws_s3_bucket_acl" "front" {
  bucket = aws_s3_bucket.front.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "front" {
  bucket = aws_s3_bucket.front.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.front.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  statement {
    sid    = "AllowCloudFrontGetBucketObject"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.default.iam_arn]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.front.arn}/*"]
  }

  statement {
    sid    = "AllowCloudFrontListBucketContents"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.default.iam_arn]
    }

    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.front.arn]
  }
}
