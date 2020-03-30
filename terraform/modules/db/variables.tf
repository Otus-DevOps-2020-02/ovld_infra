variable zone {
  type        = string
  description = "Zone"
  default     = "europe-west1-b"
}
variable db_disk_image {
  type        = string
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
variable env {
  type        = string
  description = "Environment"
}