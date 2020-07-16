##
# Module to setup confluent platform instances on Google Cloud
##

module "confluent-cluster" {
  source = "./confluent-platform"
  brokers = 3
  zookeepers = 3

  project = "solutionsarchitect-01"
  credentials_file = "credentials.json"

  name = "pub"

  region = "europe-west1"
  zones = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]

  myip  = "89.14.163.186"
  gce_ssh_pub_key_file = "/Users/pere/.ssh/id_rsa_gcloud.pub"
}
