
variable "project" { }

variable "credentials_file" { }

variable "region" {
  default = "europe-west3"
}

variable "zone" {
  default = "europe-west3-a"
}

variable "zones" {
  type = list(string)
  default = []
  description = "Zones available in the selected region"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "machine_types" {
  type    = map
  default = {
    dev  = "f1-micro"
    prod = "n1-highcpu-32"
  }
}

variable "image_type" {
  default = "rhel-cloud/rhel-7"
}

variable "name" {
  type = string
  #default = ""
}

variable "brokers" {
  type = number
  default = 1
}

variable "gce_ssh_user" {
  default = "admin"
}

variable "gce_ssh_pub_key_file" {
#  default = "/Users/pere/.ssh/id_rsa_gcloud.pub"
}

provider "google" {

  version = "3.5.0"
  credentials = file(var.credentials_file)

  project = var.project
  region = var.region
  zone = var.zone

}
