variable project {
  type        = string
  description = "Project ID"
}
variable env {
  type        = string
  description = "Environment"
}
variable region {
  type        = string
  description = "Region"
  default     = "europe-west1"
}
variable zone {
  type        = string
  description = "Zone"
  default     = "europe-west1-b"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}