
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

  can_ip_forward = true
}

resource "google_compute_instance" "zokeepper" {
  name         = "${var.name}-zokeepper-${count.index}"
  count        = var.brokers
  machine_type = var.machine_types[var.environment]["zookeeper"]
  tags         = [var.name, "kafka", "zookeeper"]
  zone         = var.zones[count.index]

  labels = {
    role = "zokeepper"
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  boot_disk {
    initialize_params {
      image = var.image_type
      type  = "pd-ssd"
      size  = var.disk_size["zokeepper"]
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  can_ip_forward = true
}
