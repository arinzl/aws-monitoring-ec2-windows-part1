
#------------------------------------------------------------------------------
# VPC Module
#------------------------------------------------------------------------------
module "demo_monitoring_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"
  # Ignoring Checkov mitigation via boundary rule added, checkov unable logging enabled in module
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV2_AWS_11: "Ensure VPC flow logging is enabled in all VPCs"
  #checkov:skip=CKV2_AWS_19: "Ensure that all EIP addresses allocated to a VPC are attached to EC2 instances"
  #checkov:skip=CKV2_AWS_12: "Ensure the default security group of every VPC restricts all traffic"
  #checkov:skip=CKV_AWS_130: "Ensure VPC subnets do not assign public IP by default"

  name = "${var.app_name}-${var.environment}-vpc"
  cidr = var.vpc_cidr_range

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.private_subnets_list
  public_subnets  = var.public_subnets_list


  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  vpc_flow_log_permissions_boundary    = aws_iam_policy.vpc_flow_logging_boundary_role_policy.arn
  flow_log_max_aggregation_interval    = 60

  create_igw         = true
  enable_nat_gateway = true
  enable_ipv6        = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags_generic

}
