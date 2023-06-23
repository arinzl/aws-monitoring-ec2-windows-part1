data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "vpc_flow_logging_boundary_role_doc" {
  statement {
    sid    = "ServiceBoundaries"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/vpc-flow-log/${module.demo_monitoring_vpc.vpc_id}:*"]
  }
}

data "aws_iam_policy_document" "demo_monitoring_ec2_assumable_doc" {
  statement {
    sid    = "readssmparameter"
    effect = "Allow"
    actions = [
      "ssm:GetParameter"
    ]
    resources = [aws_ssm_parameter.cw_agent.arn]
  }


  statement {
    sid    = "test"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.demo_monitoring_windows_event_application_log_group}:*",
    "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.demo_monitoring_windows_iis_log_group}:*"]
  }

  statement {
    sid    = "KMSkeySSMParameter"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:*"
    ]
    resources = [aws_kms_key.demo_monitoring_kms_key.arn]
  }

}


data "aws_ami" "windows-server-2022" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "Windows_Server-2022-English-Full-Base*"
}
