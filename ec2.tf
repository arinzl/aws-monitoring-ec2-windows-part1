#-------------------------------------------------------------------
# Demo Monitoring Server Configuration
#-------------------------------------------------------------------
module "demo_monitoring_server01" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.5.0"

  #checkov:skip=CKV_AWS_8: "Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted"
  #checkov:skip=CKV_AWS_126: "Ensure that detailed monitoring is enabled for EC2 instances"
  #checkov:skip=CKV_AWS_79: "Ensure Instance Metadata Service Version 1 is not enabled"

  depends_on = [aws_ssm_parameter.cw_agent]

  name = "${var.app_name}-${var.environment}-01"

  ami                         = data.aws_ami.windows-server-2022.id
  instance_type               = "t3.medium"
  subnet_id                   = module.demo_monitoring_vpc.private_subnets[2]
  availability_zone           = module.demo_monitoring_vpc.azs[2]
  associate_public_ip_address = false
  vpc_security_group_ids      = [module.demo_server_sg.security_group_id]
  iam_instance_profile        = module.demo_monitoring_ec2_assumable_role.iam_instance_profile_id
  user_data_base64            = base64encode(local.user_data_prod)
  private_ip                  = var.demo_server_private_ip
  disable_api_termination     = false


  #  CKV_AWS_79: "Ensure Instance Metadata Service Version 1 is not enabled"
  metadata_options = {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }


  enable_volume_tags = false
  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 80
      encrypted   = true
      kms_key_id  = aws_kms_key.demo_monitoring_kms_key.arn

      tags = {
        Name = "Demo-Monitoring-C-Drive"
      }
    },
  ]

  tags = merge(local.tags_generic)


}

resource "aws_ebs_volume" "demo_monitoring_d_drive" {

  size              = 30
  type              = "gp3"
  availability_zone = module.demo_monitoring_vpc.azs[2]
  encrypted         = true
  kms_key_id        = aws_kms_key.demo_monitoring_kms_key.arn

  tags = {
    Name = "Demo-Monitoring-D-Drive"
  }

}

resource "aws_volume_attachment" "demo_monitoring_d_drive_attachment" {

  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.demo_monitoring_d_drive.id
  instance_id = module.demo_monitoring_server01.id

}
