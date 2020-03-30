terraform {
  backend "gcs" {
    bucket = "storage-bucket-terraform"
    prefix  = "prod-tfstate"
  }
}