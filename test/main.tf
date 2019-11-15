module "s3-cloudfront-page" {
  source       = ".."
  version      = "0.1.0"
  domain_name  = "www.example.com"
  root         = "${path.module}/public"
  filter_paths = ".*/font-awesome/(sprites|svgs)/.*"
}

output "cloudfront" {
  value = module.s3-cloudfront-page.cloudfront
}
