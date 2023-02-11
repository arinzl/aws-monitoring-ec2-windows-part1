environment          = "test"
vpc_cidr_range       = "172.17.0.0/20"
private_subnets_list = ["172.17.0.0/24", "172.17.1.0/24", "172.17.2.0/24"]
public_subnets_list  = ["172.17.3.0/24", "172.17.4.0/24", "172.17.5.0/24"]
app_name             = "demo-monitoring"

#------------------------------------------------------------------------------
# EC2
#------------------------------------------------------------------------------

demo_server_private_ip = "172.17.2.34"

#------------------------------------------------------------------------------
#  Monitoring
#------------------------------------------------------------------------------

demo_monitoring_namespace                           = "demo-monitoring"
demo_monitoring_enabled                             = true
demo_monitoring_service_sploorer_alarm_enabled      = true
demo_monitoring_events_application_alarm_enabled    = true
demo_monitoring_log_iis_alarm_enabled               = true
demo_monitoring_cpu_utilization_threshold           = 80    # percent
demo_monitoring_disk_free_threshold                 = 10    # percent
demo_monitoring_memory_available_Mbytes_threshold   = 614.4 # 4x1024*.15 
demo_monitoring_windows_iis_log_group               = "/demo-monitoring-iis-logs"
demo_monitoring_windows_event_application_log_group = "/demo-monitoring-application-logs"
