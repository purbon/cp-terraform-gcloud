variable "disk_size" {
  type    = map
  default = {
    bastion   = 512
    broker    = 1024
    zokeepper = 1024
    connect   = 512
  }
}

resource "google_compute_attached_disk" "broker" {
  disk     = element(google_compute_disk.broker.*.id, count.index)
  instance = element(google_compute_instance.broker.*.id, count.index)
  count    = var.brokers
}

resource "google_compute_disk" "broker" {
  name  = "${var.name}-broker-${count.index}-disk"
  count = var.brokers
  type  = "pd-standard"
  zone  = var.zones[count.index]
  image = var.image_type
  labels = {
    environment = var.environment
  }
  size = var.disk_size["broker"]
  physical_block_size_bytes = 4096
}
