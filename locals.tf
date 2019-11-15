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

    // common web documents
    css  = "text/css"
    htm  = "text/html"
    html = "text/html"
    js   = "text/javascript"
    json = "application/json"
    map  = "application/json"
    xml  = "application/xml"

    // images
    gif  = "image/gif"
    ico  = "image/x-icon"
    jpeg = "image/jpeg"
    jpg  = "image/jpeg"
    png  = "image/png"
    svg  = "image/svg+xml"
    tif  = "image/tiff"
    tiff = "image/tiff"

    // fonts
    eot   = "application/vnd.ms-fontobject"
    ttf   = "font/ttf"
    woff  = "font/woff"
    woff2 = "font/woff2"

    // archives
    gz  = "application/gzip"
    tar = "application/gzip"
    zip = "application/zip"

    // media
    mp3  = "audio/mpeg"
    mp4  = "video/mp4"
    mpeg = "video/mpeg"

    // documents
    doc  = "application/msword"
    docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    dot  = "application/msword"
    pdf  = "application/pdf"
    pot  = "application/mspowerpoint"
    pps  = "application/mspowerpoint"
    ppt  = "application/mspowerpoint"
    ppz  = "application/mspowerpoint"
    rtf  = "application/rtf"
    txt  = "text/plain"
    xls  = "application/vnd.ms-excel"
    xlsx = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  }
  valid_files = merge(local.default_filetypes, var.additional_filetypes)
}
