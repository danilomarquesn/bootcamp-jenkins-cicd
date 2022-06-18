locals {
  
  tags = {
    Terraform   = "true"
    Environment = "prod"
    Company     = "Impacta"
    Project     = "Bootcamp"
    Year        = "2022"
    Team        = "MBA CLC and DevOps 07"
  }

  eip_tags = {
    Name = "Jenkins-Elastic-Ip"
  }
}