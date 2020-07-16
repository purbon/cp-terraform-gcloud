variable "disk_size" {
  type    = map
  default = {
    bastion = 512
    broker  = 1024
    zokeepper = 1024
  }
}
