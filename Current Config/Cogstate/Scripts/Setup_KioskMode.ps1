## The following script setups the Cogstate User account in Kiosk Mode.

# Define Script Variables, task details found below for error catching
# Start transcript for detailed logging
$logFile = "C:\Windows\Setup\Cogstate\Scripts\Logs\KioskSchTask_log.txt"
Start-Transcript -Path $logFile -Append

try{
    Write-Host "Setting up Cogstate User Account in Kiosk Mode"

    # Define task details
    $taskName = 'CogstateKiosk'
    $username = 'Cogstate'

    # Define task actions
    $action1 = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument 'taskkill /f /im explorer.exe'
    $action2 = New-ScheduledTaskAction -Execute 'C:\Program Files\Google\Chrome\Application\chrome.exe' -Argument '-kiosk https://cogstate.login.redcapcloud.com/'
    $actions = @($action1, $action2)

    # Define task principal, trigger, and settings
    $principal = New-ScheduledTaskPrincipal -UserId $username -RunLevel Highest
    $trigger = New-ScheduledTaskTrigger -AtLogon -User $username
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    # Create and register the scheduled task
    $task = New-ScheduledTask -Action $actions -Principal $principal -Settings $settings -Trigger $trigger
    Register-ScheduledTask -TaskName $taskName -InputObject $task -ErrorAction Stop

    Write-Host "Cogstate Kiosk setup complete." -ForegroundColor Green
    } catch {
    Write-Host "Error occurred: $_" -ForegroundColor Red
}

# Stop transcript
Stop-Transcript