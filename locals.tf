locals {
  clean_domain_name = replace(var.domain_name, "/\\./", "_")
  split_domain_name = split(".", var.domain_name)
  root_domain_name = join(
    ".",
    slice(
      local.split_domain_name,
      1,
      length(local.split_domain_name)
    )
  )
  default_filetypes = { // Only files types in this list will be synced to S3
    html  = "text/html"
    css   = "text/css"
    js    = "text/javascript"
    pdf   = "application/pdf"
    ico   = "image/x-icon"
    png   = "image/png"
    gif   = "image/gif"
    jpg   = "image/jpeg"
    jpeg  = "image/jpeg"
    map   = "application/json"
    eot   = "application/vnd.ms-fontobject"
    svg   = "image/svg+xml"
    ttf   = "font/ttf"
    woff  = "font/woff"
    woff2 = "font/woff2"
  }
  valid_files = merge(local.default_filetypes, var.additional_filetypes)
}
