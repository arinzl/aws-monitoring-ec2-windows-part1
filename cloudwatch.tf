#------------------------------------------------------------------------------
# EC2 alarms
#------------------------------------------------------------------------------


resource "aws_cloudwatch_metric_alarm" "demo_monitoring_os_cpu_utilization" {
  count = (var.demo_monitoring_cpu_utilization_threshold > 0 && var.demo_monitoring_enabled) ? 1 : 0

  alarm_name          = "${var.app_name}-ec2-cpu-utilization"
  alarm_description   = "Average CPU utilization alarm activated when CPU utilisation over threshold."
  namespace           = var.demo_monitoring_namespace
  metric_name         = "Processor % Processor Time"
  statistic           = "Average"
  datapoints_to_alarm = 3
  period              = 60
  evaluation_periods  = 3
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.demo_monitoring_cpu_utilization_threshold
  alarm_actions       = [module.demo_monitoring_sns_topic.sns_topic_arn]
  ok_actions          = [module.demo_monitoring_sns_topic.sns_topic_arn]
  dimensions = {
    InstanceId = module.demo_monitoring_server01.id
    instance   = "_Total"
    objectname = "Processor"
  }
  treat_missing_data = "breaching"

  tags = merge(local.tags_generic)
}

resource "aws_cloudwatch_metric_alarm" "demo_monitoring_os_mem_free" {
  count = (var.demo_monitoring_memory_available_Mbytes_threshold > 0 && var.demo_monitoring_enabled) ? 1 : 0

  alarm_name          = "${var.app_name}-ec2-memory-free"
  alarm_description   = "Average Memory free (MBytes) alarm activated when memory is less the threshold."
  namespace           = var.demo_monitoring_namespace
  metric_name         = "Memory Available Mbytes"
  statistic           = "Average"
  datapoints_to_alarm = 3
  period              = 60
  evaluation_periods  = 3
  comparison_operator = "LessThanThreshold"
  threshold           = var.demo_monitoring_memory_available_Mbytes_threshold
  alarm_actions       = [module.demo_monitoring_sns_topic.sns_topic_arn]
  ok_actions          = [module.demo_monitoring_sns_topic.sns_topic_arn]
  dimensions = {
    InstanceId = module.demo_monitoring_server01.id
  }
  treat_missing_data = "breaching"

  tags = merge(local.tags_generic)
}

resource "aws_cloudwatch_metric_alarm" "demo_monitoring_os_logicaldrive_c_percent_freespace" {
  count = (var.demo_monitoring_disk_free_threshold > 0 && var.demo_monitoring_enabled) ? 1 : 0

  alarm_name          = "${var.app_name}-ec2-drive-free-space-c"
  alarm_description   = "Free disk space alarm is activated when disk space is less than threshold (percentage)."
  namespace           = var.demo_monitoring_namespace
  metric_name         = "LogicalDisk % Free Space"
  statistic           = "Average"
  datapoints_to_alarm = 3
  period              = 60
  evaluation_periods  = 3
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = var.demo_monitoring_disk_free_threshold
  alarm_actions       = [module.demo_monitoring_sns_topic.sns_topic_arn]
  ok_actions          = [module.demo_monitoring_sns_topic.sns_topic_arn]
  dimensions = {
    InstanceId = module.demo_monitoring_server01.id
    instance   = "C:"
    objectname = "LogicalDisk"
  }
  treat_missing_data = "breaching"

  tags = merge(local.tags_generic)
}


resource "aws_cloudwatch_metric_alarm" "demo_monitoring_os_logicaldrive_d_percent_freespace" {
  count = (var.demo_monitoring_disk_free_threshold > 0 && var.demo_monitoring_enabled) ? 1 : 0

  alarm_name          = "${var.app_name}-ec2-drive-free-space-d"
  alarm_description   = "Free disk space alarm is activated when disk space is less than threshold (percentage)."
  namespace           = var.demo_monitoring_namespace
  metric_name         = "LogicalDisk % Free Space"
  statistic           = "Average"
  datapoints_to_alarm = 3
  period              = 60
  evaluation_periods  = 3
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = var.demo_monitoring_disk_free_threshold
  alarm_actions       = [module.demo_monitoring_sns_topic.sns_topic_arn]
  ok_actions          = [module.demo_monitoring_sns_topic.sns_topic_arn]
  dimensions = {
    InstanceId = module.demo_monitoring_server01.id
    instance   = "D:"
    objectname = "LogicalDisk"
  }
  treat_missing_data = "breaching"

  tags = merge(local.tags_generic)
}


resource "aws_cloudwatch_metric_alarm" "demo_monitoring_os_spooler_service" {
  count = (var.demo_monitoring_service_sploorer_alarm_enabled && var.demo_monitoring_enabled) ? 1 : 0

  alarm_name          = "${var.app_name}-service-spooler"
  alarm_description   = "Spooler service"
  namespace           = var.demo_monitoring_namespace
  metric_name         = "procstat memory_rss"
  statistic           = "Minimum"
  datapoints_to_alarm = 2
  period              = 60
  evaluation_periods  = 3
  comparison_operator = "LessThanThreshold"
  threshold           = 123
  alarm_actions       = [module.demo_monitoring_sns_topic.sns_topic_arn]
  ok_actions          = [module.demo_monitoring_sns_topic.sns_topic_arn]
  dimensions = {
    InstanceId   = module.demo_monitoring_server01.id
    exe          = "spoolsv"
    process_name = "spoolsv.exe"
  }
  treat_missing_data = "breaching"

  tags = merge(local.tags_generic)
}


resource "aws_cloudwatch_metric_alarm" "demo_monitoring_windows_events_Error_demo" {
  count = (var.demo_monitoring_events_application_alarm_enabled && var.demo_monitoring_enabled) ? 1 : 0

  alarm_name          = "${var.app_name}-windows-events-appliation-log-error-demo"
  alarm_description   = "Alert on word demo with serverity Error in application log if found more the 3 times a minute"
  namespace           = var.demo_monitoring_namespace
  metric_name         = "ERROR-demo-occurances"
  statistic           = "Sum"
  datapoints_to_alarm = 1
  period              = 60
  evaluation_periods  = 1
  comparison_operator = "GreaterThanThreshold"
  threshold           = 2
  alarm_actions       = [module.demo_monitoring_sns_topic.sns_topic_arn]
  ok_actions          = [module.demo_monitoring_sns_topic.sns_topic_arn]
  treat_missing_data  = "notBreaching"

  tags = merge(local.tags_generic)
}

#------------------------------------------------------------------------------
# Log groups 
#------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "demo_monitoring_iis_logs" {
  name              = var.demo_monitoring_windows_iis_log_group
  retention_in_days = 3
  kms_key_id        = aws_kms_key.demo_monitoring_kms_key.arn

  tags = merge(local.tags_generic)
}

resource "aws_cloudwatch_log_group" "demo_monitoring_applicaiton_logs" {
  name              = var.demo_monitoring_windows_event_application_log_group
  retention_in_days = 7
  kms_key_id        = aws_kms_key.demo_monitoring_kms_key.arn

  tags = merge(local.tags_generic)
}

#------------------------------------------------------------------------------
# Log group filter 
#------------------------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "demo_monitoring_applicaiton_filter" {
  name           = "demo-monitoring-applicaiton-filter"
  pattern        = " \"[ERROR]\" \"[567]\" demo"
  log_group_name = aws_cloudwatch_log_group.demo_monitoring_applicaiton_logs.name

  metric_transformation {
    name      = "ERROR-demo-occurances"
    namespace = var.app_name
    value     = "1"
  }
}
