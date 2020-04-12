resource "google_compute_instance" "app_with_deploy" {
  count        = var.deploy == true ? 1 : 0
  name         = "${var.env}-reddit-app"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["${var.env}-reddit-app", "app", var.env]

  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }

  metadata = {
    ssh-keys = "${var.user}:${file(var.ssh_pub_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = google_compute_address.app_ip.address
    user        = var.user
    agent       = false
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "file" {
    content     = templatefile("${path.module}/files/puma.service.tpl", { db_ip = var.db_ip, db_port = var.db_port, user = var.user })
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }

}

resource "google_compute_instance" "app_without_deploy" {
  count        = var.deploy == false ? 1 : 0
  name         = "${var.env}-reddit-app"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["${var.env}-reddit-app", "app", var.env]

  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  network_interface {
    network = "default"
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
