resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to configure Server metrics and alarms"
  name        = "/demo-monitoring/cloudwatch-agent/config"
  type        = "String"
  value       = file("app_cw_agent_config.json")

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"

  tags = merge(local.tags_generic)
}
