
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
    ports    = ["22"]
  }

  source_ranges = [ "89.14.163.186/32" ]
  source_tags = ["kafka"]
  target_tags = ["kafka"]
}

resource "google_compute_firewall" "brokers" {
  name    = "confluent-platform-broker-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "9092"]
  }

  source_ranges = [ "89.14.163.186/32" ]
  source_tags = ["bastion"]
  target_tags = ["broker"]
}

resource "google_compute_network" "vpc_network" {
  name = "pub-kafka-network"
}
