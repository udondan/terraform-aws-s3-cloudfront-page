# S3 CloudFront page

[![Actions Status](https://github.com/udondan/terraform-aws-s3-cloudfront-page/workflows/Terraform/badge.svg)](https://github.com/udondan/terraform-aws-s3-cloudfront-page/blob/master/.github/workflows/main.yml)

Terraform module for publishing a static page via AWS CloudFront.

- S3 bucket creation
- Syncing `root` folder to S3 via Terraform resource (not local-exec) and therefore:
  - you'll see all planned object changes in a `terraform plan`
  - works nicely with Terraform Cloud.
- Creates CloudFront distribution
- Creates SSL certificate
- Installs Lambda function for invalidating CloudFront cache, triggered by changes on S3 objects

The module **does not** take care of the DNS record. You need to create a CNAME record for your domain pointing to the CloudFront domain name.

## Usage

```hcl
module "s3-cloudfront-page" {
  source       = "udondan/s3-cloudfront-page/aws"
  version      = "0.2.0"
  domain_name  = "www.example.com" // www. or any other subdomain is mandatory! Apex records are not supported at this time
  root         = "./public"
}

output "cloudfront" {
  value = module.s3-cloudfront-page.cloudfront
}
```

In above example the content of the directory `./public` will be synced to S3 and made available via CloudFront. The CloudFront domain name will be returned as an output, which you need to use as a CNAME record for your domain.

```output
Outputs:

cloudfront = {
  "domain" = "d125amghsb8rur.cloudfront.net"
  "id" = "EY3RKBX1BZS2T"
}
```

```dig
www.example.com. 3600 IN CNAME d125amghsb8rur.cloudfront.net.
```

During the `terraform apply` an SSL certificate will be generated. The administrative contact(s) of the domain will receive an email requesting confirmation.

When initially applying, bring some patience. Creating a new CloudFront distribution can take >20 minutes.

---

In case your public folder contains content you do not want to sync to s3, you can provide a filter. This might be interesting if you use JavaScript or font libraries which contain files you don't need to serve to customers. E.g. [Font Awesome](https://fontawesome.com/) contains some 1600 sprite and svg files not required by the frontend. You can filter them like so:

```hcl
module "s3-cloudfront-page" {
  source       = "udondan/s3-cloudfront-page/aws"
  version      = "0.2.0"
  domain_name  = "www.example.com"
  root         = "./public"
  filter_paths = ".*/font-awesome/(sprites|svgs)/.*"
}
```

Why should you care? Each file will be synced by Terraform as a separate resource. Even when there are no changes, Terraform will require quite some time to compare the state with the local files.

---

By default only file with these extensions will be synced to S3:

- css
- doc
- docx
- dot
- eot
- gif
- gz
- htm
- html
- ico
- jpeg
- jpg
- js
- json
- map
- mp3
- mp4
- mpeg
- pdf
- png
- pot
- pps
- ppt
- ppz
- rtf
- svg
- tar
- tif
- tiff
- ttf
- txt
- woff
- woff2
- xls
- xlsx
- xml
- zip

If you need to sync additional file types, you need to provide the expected mime type:

```hcl
module "s3-cloudfront-page" {
  source      = "udondan/s3-cloudfront-page/aws"
  version     = "0.2.0"
  domain_name = "www.example.com"
  root        = "./public"
  additional_filetypes = {
    swf = "application/x-shockwave-flash"
  }
}
```
