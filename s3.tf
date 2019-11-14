locals {
  s3_files = fileset(var.root, "**/*") // all files in the given directory
  s3_files_filtered = toset([for v in local.s3_files : v if(
    contains(
      keys(local.valid_files),  // valid file extensions
      reverse(split(".", v))[0] // file extension of v
      ) && (
      var.filter_paths == "" ||
    length(regexall(var.filter_paths, v)) == 0) // invalid paths
    )
  ])
  valid_files = merge(var.default_filetypes, var.additional_filetypes)
}

data "aws_iam_policy_document" "s3_public_read_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.domain_name}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "www" {
  bucket = var.domain_name
  acl    = "private"
  policy = data.aws_iam_policy_document.s3_public_read_policy.json
  website {
    index_document = var.index_document
    error_document = var.error_document
  }
}

resource "aws_s3_bucket_notification" "www" {
  bucket = aws_s3_bucket.www.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.cloudfront_invalidator.arn
    events = [
      "s3:ObjectCreated:*",
      "s3:ObjectRemoved:*",
    ]
  }
  depends_on = [
    aws_lambda_permission.cloudfront_invalidator
  ]
}

resource "aws_s3_bucket_object" "www" {
  for_each = local.s3_files_filtered
  bucket   = aws_s3_bucket.www.bucket
  key      = replace(each.value, "${var.root}/", "")
  source   = "${var.root}/${each.value}"
  etag     = filemd5("${var.root}/${each.value}")
  content_type = lookup(
    local.valid_files,
    reverse(split(".", each.value))[0],
    "application/octet-stream" // fallback mimetype. should not ever happen, since we use the defined mimetypes as filter
  )
}
