locals {
  region = "ap-southeast-2"

  tags_generic = {
    appname     = var.app_name
    environment = var.environment
    costcentre  = "TBC"
    ManagedBy   = var.ManagedByLocation
  }

  tags_ssm_ssm = {
    Name = "myvpc-vpce-interface-ssm-ssm"
  }

  tags_ssm_ssmmessages = {
    Name = "myvpc-vpce-interface-ssm-ssmmessages"
  }

  tags_ssm_ec2messages = {
    Name = "myvpc-vpce-interface-ssm-ec2messages"
  }


  user_data_prod = <<EOT
<powershell>
  Set-TimeZone -Name "New Zealand Standard Time"
  New-Item -Path "c:\temp" -Name "logfiles" -ItemType "directory"

  Install-WindowsFeature -name Web-Server -IncludeManagementTools
  Start-Sleep -Seconds 120
  New-Item -Path C:\inetpub\wwwroot\index.html -ItemType File -Value "Welcome to the Monitoring Demo IIS Webserver Home Page " -Force
  Set-Service -name W3SVC -startupType Automatic

  Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing
  Invoke-WebRequest -Uri "http://localhost/fail" -UseBasicParsing

  # Get-Disk | Where partitionstyle -eq ‘raw’ | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel “disk2” -Confirm:$false
  # Start-Sleep -Seconds 30

  ## CW Agent install
  c:
  cd \temp
  Invoke-WebRequest -Uri https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/amazon-cloudwatch-agent.msi -OutFile c:\temp\amazon-cloudwatch-agent.msi
  & msiexec /i "c:\temp\amazon-cloudwatch-agent.msi" /l*v "cw_agent_install.log"
  Start-Sleep -Seconds 60
  & $env:ProgramFiles\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -c ssm:/demo-monitoring/cloudwatch-agent/config -s
  
  Start-Sleep -Seconds 120

  # New-EventLog –LogName "Application" –Source “My Demo"
  # Write-EventLog –LogName "Application" –Source “My Demo" –EntryType "Error" –EventID 567 –Message “Test message for monitoring demo filter pattern.”

  # Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing
  # Invoke-WebRequest -Uri "http://localhost/fail" -UseBasicParsing

</powershell>
  EOT

}




