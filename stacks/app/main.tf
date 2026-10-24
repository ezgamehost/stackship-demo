# Stand-in fleet of game servers. Uses only the random provider and
# terraform_data, so StackShip can plan and apply it without cloud credentials.
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

variable "game" {
  type    = string
  default = "minecraft"
}

variable "server_count" {
  type    = number
  default = 3
}

resource "random_pet" "server" {
  count  = var.server_count
  prefix = var.game
}

resource "random_password" "rcon" {
  count   = var.server_count
  length  = 24
  special = false
}

resource "terraform_data" "server" {
  count = var.server_count

  input = {
    hostname = "${random_pet.server[count.index].id}.play.example.com"
    port     = 25565 + count.index
  }
}

output "servers" {
  value = [for server in terraform_data.server : server.output.hostname]
}

output "rcon_passwords" {
  value     = random_password.rcon[*].result
  sensitive = true
}
