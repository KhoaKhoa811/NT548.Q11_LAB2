module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.19.1"

  # checkov:skip=CKV_AWS_39:Public access is needed for student lab access
  # checkov:skip=CKV_AWS_38:KMS encryption is disabled to simplify setup
  # checkov:skip=CKV_AWS_37:CloudWatch logging is disabled to reduce costs
  # checkov:skip=CKV_AWS_58:Public access is enabled for student convenience
  cluster_name    = local.cluster_name
  cluster_version = "1.30"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnet_ids
  cluster_endpoint_public_access = true

  # Disable KMS encryption entirely (requires kms:CreateKey permission otherwise)
  create_kms_key                   = false
  cluster_encryption_config        = {}
  attach_cluster_encryption_policy = false

  # Use existing CloudWatch log group if it exists
  create_cloudwatch_log_group = false

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}
