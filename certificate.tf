resource "aws_acm_certificate" "certificate" {
  domain_name       = var.domain_name
  validation_method = "EMAIL"
  lifecycle {
    create_before_destroy = true
  }
}
