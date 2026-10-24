# Stand-in network for a game-hosting region. Uses only the random provider and
# terraform_data, so StackShip can plan and apply it without cloud credentials.
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

variable "region" {
  type    = string
  default = "us-west"
}

variable "zones" {
  type    = list(string)
  default = ["a", "b", "c"]
}

resource "random_pet" "network" {
  prefix = var.region
  length = 2
}

resource "random_integer" "second_octet" {
  min = 16
  max = 31
}

resource "terraform_data" "subnet" {
  for_each = toset(var.zones)

  input = {
    name = "${random_pet.network.id}-${each.key}"
    cidr = cidrsubnet("10.${random_integer.second_octet.result}.0.0/16", 8, index(var.zones, each.key))
  }
}

output "network_name" {
  value = random_pet.network.id
}

output "subnets" {
  value = { for zone, subnet in terraform_data.subnet : zone => subnet.output.cidr }
}
