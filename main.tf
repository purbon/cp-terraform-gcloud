##
# Module to setup confluent platform instances on Google Cloud
##

variable "project" { }

variable "credentials_file" { }

module "confluent-cluster" {
  source = "./confluent-platform"
  brokers = 2
  zookeepers = 1
  connects = 0

  name = "pub"
  project = var.project
  credentials_file = var.credentials_file

  region = "europe-west1"
  zones = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]

  myip  = "89.14.163.186"
  gce_ssh_pub_key_file = "/Users/pere/.ssh/id_rsa_gcloud.pub"
}
