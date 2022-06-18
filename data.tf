# Data of Subnet

data "aws_subnet" "bootcamp_public_sub_2a" {
  filter {
    name   = "tag:Name"
    values = ["bootcamp-vpc-public-us-east-2a"]
  }

  depends_on = [
    module.vpc
  ]
}

# Key

data "aws_key_pair" "bootcamp_keypair" {
  key_name = "bootcamp"
  filter {
    name   = "tag:Name"
    values = ["bootcamp"]
  }
}