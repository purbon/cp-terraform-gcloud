
resource "google_compute_address" "vm_static_ip" {
  name = "pub-kafka-static-ip"
}


resource "google_compute_firewall" "default" {
  name    = "confluent-platform-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080"]
  }

  source_ranges = [ "89.14.163.186/32" ]
  target_tags = ["kafka"]
}

resource "google_compute_network" "vpc_network" {
  name = "pub-kafka-network"
}
