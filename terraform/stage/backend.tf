terraform {
  backend "gcs" {
    bucket = "storage-bucket-terraform"
    prefix = "stage-tfstate"
  }
}
