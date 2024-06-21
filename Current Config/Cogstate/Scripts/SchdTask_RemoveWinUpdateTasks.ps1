## The following script schedules a task to run the CheckService_WaasMedicSvc script at startup.

# Define Script Variables
# Path to Startup Script
$ScriptPath = "C:\Windows\Setup\Cogstate\Scripts\CheckService_WaaSMedicSvc.ps1"
# Path to Log File
$logFile = "C:\Windows\Setup\Cogstate\Scripts\Logs\SchTask_log.txt"

# Start transcript for detailed logging
Start-Transcript -Path $logFile -Append

try{
# Create a new scheduled task action to run the script with error logging
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -Command `"& { &'$ScriptPath'; if (`$? -eq `$false) {exit 1}} > '$LogPath' 2>&1`""

# Create a trigger to run the task at startup
$Trigger = New-ScheduledTaskTrigger -AtStartup

# Register the scheduled task
Register-ScheduledTask -TaskName "CheckService_WaaSMedicSvc" -Action $Action -Trigger $Trigger -RunLevel Highest -Force

Write-Host "Scheduled task to check for WaaSMedicSv at startup." -ForegroundColor Green
} catch {
    Write-Host "Error occured: $_" -ForegroundColor Red
}

# Stop  transcript
Stop-Transcript