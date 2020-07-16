
resource "google_compute_instance" "vm_instance" {
  name         = "${var.name}-bastion"
  machine_type = var.machine_types[var.environment]
  tags         = [var.name, "kafka", "bastion"]

  labels = {
    role = "bastion"
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  boot_disk {
    initialize_params {
      image = var.image_type
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  can_ip_forward = true
}

resource "google_compute_instance" "brokers" {
  name         = "${var.name}-broker-${count.index}"
  count        = var.brokers
  machine_type = var.machine_types[var.environment]
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
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  can_ip_forward = true
}
