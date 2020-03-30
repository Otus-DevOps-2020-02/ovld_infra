terraform {
  required_version = "~> 0.12.0"
}

provider "google" {
  version = "~> 2.5.0"
  project = var.project
  region  = var.region
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.3.1"
  name    = "storage-bucket-terraform"
  location    = var.region
}

output storage-bucket_url {
  value = module.storage-bucket.url
}
