# S3 CloudFront page

Terraform module for publishing a static page via AWS CloudFront.

This module creates all required resources, except those related to the domain record. You need to create a CNAME record for your domain pointing to the CloudFront domain name.

This module also takes care of syncing the content to the S3 bucket via Terraform resources (not local-exec) and therefore works nicely with Terraform Cloud.

Futhermore a lambda function will be deployed which will invalidate CloudFront objects whenever a file is updated on S3.

## Usage

```hcl
module "s3-cloudfront-page" {
  source       = "udondan/s3-cloudfront-page/aws"
  version      = "0.1.0"
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

---

In case your public folder contains content you do not want to sync to s3, you can provide a filter. This might be interesting if you use JavaScript or font libraries which contain files you don't need to serve to customers. E.g. [Font Awesome](https://fontawesome.com/) contains some 1700 sprite and svg files not required by the frontend. You can filter them like so:

```hcl
module "s3-cloudfront-page" {
  source       = "udondan/s3-cloudfront-page/aws"
  version      = "0.1.0"
  domain_name  = "www.example.com"
  root         = "./public"
  filter_paths = ".*/font-awesome/(sprites|svgs)/.*"
}
```

By default only file with these extensions will be synced to S3:

- html
- css
- js
- pdf
- ico
- png
- gif
- jpg
- jpeg
- map
- eot
- svg
- ttf
- woff
- woff2

If you need to sync additional file types, you need to provide the expected mime type:

```hcl
module "s3-cloudfront-page" {
  source      = "udondan/s3-cloudfront-page/aws"
  version     = "0.1.0"
  domain_name = "www.example.com"
  root        = "./public"
  additional_filetypes = {
    zip = "application/zip",
    mp3 = "audio/mpeg",
    mp4 = "video/mp4",
  }
}
```
