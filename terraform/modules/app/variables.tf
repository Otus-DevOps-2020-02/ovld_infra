variable zone {
  type        = string
  description = "Zone"
  default     = "europe-west1-b"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable env {
  type        = string
  description = "Environment"
}
variable db_ip {
  type        = string
  description = "DATABASE_IP"
  default     = "127.0.0.1"
}
variable db_port {
  type        = string
  description = "DATABASE_PORT"
  default     = "27017"
}
variable user {
  type        = string
  description = "User"
  default     = "vld"
}
variable ssh_pub_key_path {
  type        = string
  description = "Public Key"
  default     = "~/.ssh/id_rsa.pub"
}
variable ssh_private_key_path {
  type        = string
  description = "Private Key"
  default     = "~/.ssh/id_rsa"
}
variable "deploy" {
  description = "If set to true, enable deploy"
  type        = bool
  default     = true
}
