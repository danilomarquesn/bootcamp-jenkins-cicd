# VPC

output "vpc-bootcamp-id" {
  value = module.vpc.vpc_id
}

output "vpc-bootcamp-arn" {
  value = module.vpc.vpc_arn
}
