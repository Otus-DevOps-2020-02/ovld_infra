terraform {
  required_version = "~> 0.12.0"
}

provider "google" {
  version = "~> 2.5.0"
  project = var.project
  region  = var.region
}

module "app" {
  source         = "../modules/app"
  zone           = var.zone
  app_disk_image = var.app_disk_image
  env            = var.env
}

module "db" {
  source        = "../modules/db"
  zone          = var.zone
  db_disk_image = var.db_disk_image
  env           = var.env
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
  env           = var.env
}
