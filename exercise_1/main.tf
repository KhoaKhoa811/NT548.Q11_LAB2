provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      local.cluster_name,
      "--region",
      var.region
    ]
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = var.clusterName
}

# 1. VPC Module
module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  cluster_name       = local.cluster_name
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets     = ["172.20.4.0/24", "172.20.5.0/24", "172.20.6.0/24"]
  private_subnets    = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
}

# 2. NAT Gateway Module
module "nat_gateway" {
  source = "./modules/nat_gateway"

  project_name     = var.project_name
  environment      = var.environment
  public_subnet_id = module.vpc.public_subnet_ids[0]
}

# 3. Route Tables Module
module "route_tables" {
  source = "./modules/route_tables"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.vpc.igw_id
  nat_gateway_id     = module.nat_gateway.nat_gateway_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}

# 4. Security Groups Module
module "security_groups" {
  source = "./modules/security_groups"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr_block          = module.vpc.vpc_cidr_block
  allowed_ssh_cidr_blocks = var.allowed_ssh_cidr_blocks
}

# 5. EC2 Module
module "ec2" {
  source = "./modules/ec2"

  project_name          = var.project_name
  environment           = var.environment
  bastion_instance_type = var.bastion_instance_type
  app_instance_type     = var.app_instance_type
  ssh_public_key        = var.ssh_public_key
  public_subnet_id      = module.vpc.public_subnet_ids[0]
  private_subnet_id     = module.vpc.private_subnet_ids[0]
  bastion_sg_id         = module.security_groups.bastion_sg_id
  app_sg_id             = module.security_groups.app_sg_id
}
