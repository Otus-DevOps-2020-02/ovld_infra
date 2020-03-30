variable zone {
  type        = string
  description = "Zone"
  default     = "europe-west1-b"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}
variable env {
  type        = string
  description = "Environment"
}