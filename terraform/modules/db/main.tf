resource "google_compute_instance" "db" {
  name         = "${var.env}-reddit-db"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["${var.env}-reddit-db"]

  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }

  network_interface {
    network  = "default"
    access_config {
    }
  }

}

resource "google_compute_firewall" "firewall_mongo" {
  name    = "${var.env}-allow-mongo"
  network = "default"
  allow {
    protocol = "tcp"
    ports   = ["27017"]
  }
  source_tags = ["${var.env}-reddit-app"]
  target_tags = ["${var.env}-reddit-db"]
}
