variable "root" {
  description = "Path to the directory that holds your public documents"
  type        = string
}

variable "domain_name" {
  description = "Name of your domain. This needs to include a subdomain! Apex records are not supported"
  type        = string
}

variable "index_document" {
  description = ""
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = ""
  type        = string
  default     = "404.html"
}

variable "additional_filetypes" {
  description = "Additional filetypes to sync to S3"
  type        = map(string)
  default     = {}
}

variable "filter_paths" {
  description = "If paths in the root folder should not be synced to S3, they can be specified here as a regular expression"
  type        = string
  default     = ""
}
