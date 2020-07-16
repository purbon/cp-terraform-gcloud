##
# Module to setup confluent platform instances on Google Cloud
##

module "confluent-cluster" {
  source = "./confluent-platform"
  brokers = 2

  project = "solutionsarchitect-01"
  credentials_file = "credentials.json"

  name = "pub"

  region = "europe-west3"
  zones = ["europe-west3-a", "europe-west3-b", "europe-west3-c"]

  gce_ssh_pub_key_file = "/Users/pere/.ssh/id_rsa_gcloud.pub"
}
