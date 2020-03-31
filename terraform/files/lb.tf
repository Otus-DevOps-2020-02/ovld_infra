resource "google_compute_forwarding_rule" "default" {
  name       = "terraform-lb-testing"
  region     = var.region
  project    = var.project
  target     = google_compute_target_pool.default.self_link
  port_range = "9292"
}

resource "google_compute_target_pool" "default" {
  name          = "terraform-lb-testing-target-pool"
  instances     = [for app in google_compute_instance.app : app.self_link]
  health_checks = [google_compute_http_health_check.default.name]
}

resource "google_compute_http_health_check" "default" {
  name               = "default"
  request_path       = "/"
  check_interval_sec = 10
  timeout_sec        = 5
  port               = 9292
}
