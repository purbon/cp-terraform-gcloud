##
# Module to setup confluent platform instances on Google Cloud
##

variable "project" { }
variable "credentials_file" { }
variable "myip" { }
variable "name" { }
variable "ssh_pub_key" { }

variable "region" { }
variable "zone"   { }
variable "zones"  { }

variable "owner_name" {
  default = ""
}

variable "owner_email" {
  default = ""
}

module "confluent-platform-network" {
  source = "./confluent-platform-network"
  name = var.name
  project = var.project
  credentials_file = var.credentials_file
  region = var.region
  zone   = var.zone
}

module "confluent-cluster" {
  source = "./confluent-platform"
  brokers = 3
  zookeepers = 3
  connects = 2
  schema-registrys = 1

  vpc_network_name = module.confluent-platform-network.vpc_net_name

  name = var.name
  project = var.project
  credentials_file = var.credentials_file
  myip = var.myip

  region = var.region
  zones = var.zones

  owner_email = var.owner_email
  owner_name = var.owner_name

  gce_ssh_pub_key_file = var.ssh_pub_key
}

module "confluent-platform-control-center" {
  source = "./confluent-platform-control-center"

  name = var.name
  project = var.project
  credentials_file = var.credentials_file
  myip = var.myip

  vpc_network_name = module.confluent-platform-network.vpc_net_name
  dns_zone = module.confluent-cluster.dns_zone

  region = var.region
  zone   = var.zone


  owner_email = var.owner_email
  owner_name = var.owner_name

  gce_ssh_pub_key_file = var.ssh_pub_key

}
