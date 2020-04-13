terraform {
  backend "gcs" {
    bucket = "storage-bucket-terraform-devops"
    prefix = "prod-tfstate"
  }
}
