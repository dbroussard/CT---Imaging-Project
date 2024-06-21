# Path to Startup Script
$ScriptPath = "C:\Windows\Cogstate\Scripts\CheckService_WaaSMedicSvc.ps1"

# Path to Log File
$LogPath = "C:\Windows\Cogstate\Scripts\Logs\SchTask_log.txt"

# Create a new scheduled task action to run the script with error logging
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -Command `"& { &'$ScriptPath'; if (`$? -eq `$false) {exit 1}} > '$LogPath' 2>&1`""

# Create a trigger to run the task at startup
$Trigger = New-ScheduledTaskTrigger -AtStartup

# Register the scheduled task
Register-ScheduledTask -TaskName "CheckService_WaaSMedicSvc" -Action $Action -Trigger $Trigger -RunLevel Highest -Force

Write-Host "Scheduled task created to run the PowerShell script at startup."
