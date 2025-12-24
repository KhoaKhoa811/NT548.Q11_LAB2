output "cluster_name" {
  description = "Amazon Web Service EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for Amazon Web Service EKS "
  value       = module.eks.cluster_endpoint
}

output "region" {
  description = "Amazon Web Service EKS Cluster region"
  value       = var.region
}

output "cluster_security_group_id" {
  description = "Security group ID for the Amazon Web Service EKS Cluster "
  value       = module.eks.cluster_security_group_id
}

# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.nat_gateway.nat_gateway_id
}

# EC2 Outputs
output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = module.ec2.bastion_public_ip
}

output "app_server_private_ip" {
  description = "Private IP of application server"
  value       = module.ec2.app_server_private_ip
}

# Security Group Outputs
output "bastion_security_group_id" {
  description = "Security group ID for bastion host"
  value       = module.security_groups.bastion_sg_id
}

output "app_security_group_id" {
  description = "Security group ID for application servers"
  value       = module.security_groups.app_sg_id
}

output "alb_security_group_id" {
  description = "Security group ID for ALB"
  value       = module.security_groups.alb_sg_id
}

output "db_security_group_id" {
  description = "Security group ID for database"
  value       = module.security_groups.db_sg_id
}
