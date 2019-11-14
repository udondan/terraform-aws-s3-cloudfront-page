resource "aws_acm_certificate" "certificate" {
  domain_name               = "*.${local.root_domain_name}"
  validation_method         = "EMAIL"
  subject_alternative_names = [local.root_domain_name]
}
