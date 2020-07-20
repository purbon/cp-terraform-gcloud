

variable "kafka-port" {
  type = number
  default = 9092
}

variable "zookeeper-port" {
  type = number
  default = 2181
}

variable "connect-port" {
  type = number
  default = 8083
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

  source_ranges = [ "${var.myip}/32" ]
  source_tags = ["kafka"]
  target_tags = ["kafka"]
}

resource "google_compute_firewall" "brokers" {
  name    = "confluent-platform-ak-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "${var.kafka-port}"]
  }

  source_ranges = [ "${var.myip}/32" ]
  source_tags = ["bastion", "broker", "connect"]
  target_tags = ["broker"]
}

resource "google_compute_firewall" "zookeepers" {
  name    = "confluent-platform-zk-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "${var.zookeeper-port}", "2888", "3888"]
  }

  source_ranges = [ "${var.myip}/32" ]
  source_tags = ["broker", "zookeeper"]
  target_tags = ["broker", "zookeeper"]
}

resource "google_compute_firewall" "connects" {
  name    = "confluent-platform-connect-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["${var.connect-port}"]
  }

  source_ranges = [ "${var.myip}/32" ]
  source_tags = ["broker", "connect"]
  target_tags = ["broker", "connect"]
}

resource "google_compute_network" "vpc_network" {
  name = "${var.name}-kafka-network"
  description = "A network for Confluent Platform"
  auto_create_subnetworks = true
}
