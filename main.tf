
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


module "network" {
  source        = "./modules/network"
  naming_prefix = local.naming_prefix
}


module "instances" {
  source        = "./modules/instances"
  key_name      = aws_key_pair.generated_key.id
  naming_prefix = local.naming_prefix
  public_subnet_id      = module.network.public_subnet_id
  ec2_security_group_id = module.network.ec2_security_group_id
}


variable "key_name" {

  default = "Terra-keypair"

}
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}


output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}


# To get the created Key-pair run: terraform output -raw private_key