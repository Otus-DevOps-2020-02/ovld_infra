resource "google_compute_instance" "app" {
  name         = "${var.env}-reddit-app"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["${var.env}-reddit-app"]

  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  network_interface {
    network  = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }

}

resource "google_compute_address" "app_ip" {
  name = "${var.env}-reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "${var.env}-allow-puma"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.env}-reddit-app"]
}
