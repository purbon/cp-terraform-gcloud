##
# Module to setup confluent platform instances on Google Cloud
##

variable "project" { }

variable "credentials_file" { }

variable "myip" { }

module "confluent-platform-network" {
  source = "./confluent-platform-network"
  name = "pub"
  project = var.project
  credentials_file = var.credentials_file
  region = "europe-west1"
  zone   = "europe-west1-b"
}

module "confluent-cluster" {
  source = "./confluent-platform"
  brokers = 3
  zookeepers = 3
  connects = 0
  schema-registrys = 2

  vpc_network_name = module.confluent-platform-network.vpc_net_name

  name = "pub"
  project = var.project
  credentials_file = var.credentials_file
  myip = var.myip

  region = "europe-west1"
  zones = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]

  gce_ssh_pub_key_file = "/Users/pere/.ssh/id_rsa_gcloud.pub"
}

module "confluent-platform-control-center" {
  source = "./confluent-platform-control-center"

  name = "pub"
  project = var.project
  credentials_file = var.credentials_file
  myip = var.myip

  vpc_network_name = module.confluent-platform-network.vpc_net_name
  dns_zone = module.confluent-cluster.dns_zone

  region = "europe-west1"
  zone   =  "europe-west1-b"

  gce_ssh_pub_key_file = "/Users/pere/.ssh/id_rsa_gcloud.pub"

}
