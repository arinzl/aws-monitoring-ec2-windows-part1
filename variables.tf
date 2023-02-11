
variable "region" {
  description = "AWS Region"
  default     = "ap-southeast-2"
  type        = string

}

variable "environment" {
  description = "AWS environment name"
  type        = string

}

variable "app_name" {
  description = "Applicaiton Name"
  type        = string

}

#------------------------------------------------------------------------------
# VPC
#------------------------------------------------------------------------------

variable "vpc_cidr_range" {
  type = string

}

variable "private_subnets_list" {
  description = "Private subnet list for infrastructure"
  type        = list(string)

}

variable "public_subnets_list" {
  description = "Public subnet list for infrastructure"
  type        = list(string)

}

#------------------------------------------------------------------------------
# Other
#------------------------------------------------------------------------------

variable "ManagedByLocation" {
  description = "IaC location"
  default     = "https://github.com/"
}



#------------------------------------------------------------------------------
#  EC2
#------------------------------------------------------------------------------

variable "demo_server_private_ip" {
  description = "Private IP address for Server"
  type        = string

}

#------------------------------------------------------------------------------
#  Monitoring
#------------------------------------------------------------------------------

variable "demo_monitoring_namespace" {
  description = "Name space for metrics and alerts"
  type        = string
}

variable "demo_monitoring_enabled" {
  description = "Switch to tunrn on/off monitoring"
  type        = bool
}



variable "demo_monitoring_service_sploorer_alarm_enabled" {
  description = "Switch to tunrn on/off element monitoring"
  type        = bool
}

variable "demo_monitoring_events_application_alarm_enabled" {
  description = "Switch to tunrn on/off windows application event log monitoring"
  type        = bool
}

variable "demo_monitoring_log_iis_alarm_enabled" {
  description = "Switch to tunrn on/off windows iis file log monitoring"
  type        = bool
}




variable "demo_monitoring_cpu_utilization_threshold" {
  description = "Maximum % CPU level before cloudwatch alarm trigger"
  type        = number
}

variable "demo_monitoring_disk_free_threshold" {
  description = "Maximum % free disk level before cloudwatch alarm trigger"
  type        = number
  default     = 90
}


variable "demo_monitoring_memory_available_Mbytes_threshold" {
  description = "Maximum % Memory level before cloudwatch alarm trigger"
  type        = number
  default     = 80
}



variable "demo_monitoring_windows_iis_log_group" {
  description = "Log group name in AWS for Windows EC2 IIS log file data"
  type        = string
}

variable "demo_monitoring_windows_event_application_log_group" {
  description = "Log group name in AWS for Windows EC2 Application log captured events"
  type        = string
}


