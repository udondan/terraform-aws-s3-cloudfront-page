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
}
