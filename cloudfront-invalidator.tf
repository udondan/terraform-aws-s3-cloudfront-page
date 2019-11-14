data "aws_iam_policy_document" "cloudfront_invalidator_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudfront_invalidator" {
  statement {
    actions   = ["cloudfront:CreateInvalidation"]
    resources = [aws_cloudfront_distribution.www_distribution.arn]
  }
}

resource "aws_iam_policy" "cloudfront_invalidator" {
  name        = "lambda-cloudfront-invalidator-${local.clean_domain_name}"
  description = "Custom policy for Lambda: cloudfront invalidator for ${var.domain_name}"
  policy      = data.aws_iam_policy_document.cloudfront_invalidator.json
}

resource "aws_iam_role" "cloudfront_invalidator" {
  name               = "cloudfront-invalidator-${local.clean_domain_name}"
  assume_role_policy = data.aws_iam_policy_document.cloudfront_invalidator_assume.json
}

resource "aws_iam_role_policy_attachment" "aws_lambda_basic_execution" {
  role       = aws_iam_role.cloudfront_invalidator.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "cloudfront_invalidator" {
  role       = aws_iam_role.cloudfront_invalidator.name
  policy_arn = aws_iam_policy.cloudfront_invalidator.arn
}

data "archive_file" "cloudfront_invalidator" {
  type        = "zip"
  source_file = "${path.module}/cloudfront-invalidator/lambda.py"
  output_path = "${path.module}/cloudfront-invalidator/lambda.zip"
}

resource "aws_lambda_function" "cloudfront_invalidator" {
  role             = aws_iam_role.cloudfront_invalidator.arn
  handler          = "lambda.handler"
  runtime          = "python3.6"
  filename         = data.archive_file.cloudfront_invalidator.output_path
  function_name    = "cloudfront_invalidator_${local.clean_domain_name}"
  source_code_hash = data.archive_file.cloudfront_invalidator.output_base64sha256
  environment {
    variables = {
      cloudfront_id = aws_cloudfront_distribution.www_distribution.id
    }
  }
}

resource "aws_lambda_permission" "cloudfront_invalidator" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudfront_invalidator.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.www.arn
}
