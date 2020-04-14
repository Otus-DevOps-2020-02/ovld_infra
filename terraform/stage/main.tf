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
  db_ip          = module.db.db_internal_ip
  deploy         = var.deploy
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

resource "local_file" "inventory" {
    content         = templatefile("templates/inventory.yml.tpl", {db_ip = module.db.db_external_ip, app_ip = module.app.app_external_ip, db_internal_ip = module.db.db_internal_ip })
    filename        = "../../ansible/inventory.${var.env}.yml"
    file_permission = "0644"

}
