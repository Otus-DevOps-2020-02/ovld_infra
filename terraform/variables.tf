variable project {
  type        = string
  description = "Project ID"
}
variable region {
  type        = string
  description = "Region"
  default     = "europe-west1"
}
variable public_key_path {
  type        = string
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  type        = string
  description = "Path to the private key used for ssh access"
}
variable disk_image {
  type        = string
  description = "Disk image"
}
variable zone {
  type        = string
  description = "Zone"
  default     = "europe-west1-b"
}
variable "ssh_users" {
  description = "ssh_users"
  type = map
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default = "reddit-db-base"
}