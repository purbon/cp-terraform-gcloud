
resource "google_compute_instance" "bastion" {
  name         = "${var.name}-bastion"
  machine_type = var.machine_types[var.environment]["bastion"]
  tags         = [var.name, "kafka", "bastion"]
  zone         = var.zones[0]

  labels = {
    role = "bastion"
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  boot_disk {
    initialize_params {
      image = var.image_type
      size  = var.disk_size["bastion"]
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  can_ip_forward = true
}

resource "google_compute_target_tcp_proxy" "brokers-proxy" {
  name            = "${var.name}-brokers-proxy"
  backend_service = google_compute_backend_service.brokers-backend-service.id
}

resource "google_compute_backend_service" "brokers-backend-service" {
  name        = "${var.name}-brokers-backend-service"
  protocol    = "TCP"
  timeout_sec = 10

  health_checks = [google_compute_health_check.brokers-health_checks.id]
  backend {
    group = google_compute_instance_group.brokers_private_group.id
  }
}

resource "google_compute_health_check" "brokers-health_checks" {
  name               = "${var.name}-brokers-health-check"
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "9000"
  }
}

# creates a group of dissimilar virtual machine instances
resource "google_compute_instance_group" "brokers_private_group" {
  name = "${var.name}-brokers-group"
  description = "Brokers instance group"
  zone = var.zone
  instances = google_compute_instance.broker.*.self_link
  named_port {
    name = "tcp"
    port = "9092"
  }
}

resource "google_compute_instance" "broker" {
  name         = "${var.name}-broker-${count.index}"
  count        = var.brokers
  machine_type = var.machine_types[var.environment]["broker"]
  tags         = [var.name, "kafka", "broker"]
  zone         = var.zones[count.index]

  labels = {
    role = "broker"
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  boot_disk {
    initialize_params {
      image = var.image_type
      type  = "pd-standard"
      size  = var.disk_size["broker"]
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

  can_ip_forward = true
}

resource "google_compute_instance" "zookeeper" {
  name         = "${var.name}-zookeeper-${count.index}"
  count        = var.zookeepers
  machine_type = var.machine_types[var.environment]["zookeeper"]
  tags         = [var.name, "kafka", "zookeeper"]
  zone         = var.zones[count.index]

  labels = {
    role = "zookeeper"
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  boot_disk {
    initialize_params {
      image = var.image_type
      type  = "pd-ssd"
      size  = var.disk_size["zookeeper"]
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  can_ip_forward = true
}


resource "google_compute_instance" "connect" {
  name         = "${var.name}-connect-${count.index}"
  count        = var.connects
  machine_type = var.machine_types[var.environment]["connect"]
  tags         = [var.name, "kafka", "connect"]
  zone         = var.zones[count.index]

  labels = {
    role = "broker"
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  boot_disk {
    initialize_params {
      image = var.image_type
      type  = "pd-standard"
      size  = var.disk_size["connect"]
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  can_ip_forward = true
}
