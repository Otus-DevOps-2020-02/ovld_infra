terraform {
  required_version = "~> 0.12.0"
}

provider "google" {
  version = "~> 2.5.0"
  project = var.project
  region  = var.region
}