
#------------------------------------------------------------------------------
# Unrestraint access for vpc flow log role to all logs - Check: CKV_AWS_111
#------------------------------------------------------------------------------
resource "aws_iam_policy" "vpc_flow_logging_boundary_role_policy" {
  name   = "vpc-flow-logging-boundary-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.vpc_flow_logging_boundary_role_doc.json

  tags = local.tags_generic
}


#--------------------------------------------------------------------------
# SSM EC2  assumable role 
#--------------------------------------------------------------------------

resource "random_id" "random_id" {
  byte_length = 5

}

module "demo_monitoring_ec2_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.17.1"

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = true

  role_name = "${var.app_name}-ec2-assumable-role-${random_id.random_id.hex}"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy" #required for cw agent
  ]

  tags = local.tags_generic
}




resource "aws_iam_policy" "demo_monitoring_ec2_assumable_policy" {
  name   = "${var.app_name}-ec2-assumable-role-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.demo_monitoring_ec2_assumable_doc.json

  tags = local.tags_generic
}

resource "aws_iam_role_policy_attachment" "demo_monitoring_ec2_assumable_role_attachement" {
  role       = module.demo_monitoring_ec2_assumable_role.iam_role_name
  policy_arn = aws_iam_policy.demo_monitoring_ec2_assumable_policy.arn
}

