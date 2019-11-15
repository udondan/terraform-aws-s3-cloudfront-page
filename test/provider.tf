provider "aws" {
  region                      = "us-east-1"
  version                     = "2.26.0"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

provider "template" {
  version = "2.1.2"
}

provider "external" {
  version = "1.2.0"
}

provider "http" {
  version = "1.1.1"
}

provider "local" {
  version = "1.3.0"
}

provider "null" {
  version = "2.1.2"
}

provider "archive" {
  version = "1.3.0"
}
