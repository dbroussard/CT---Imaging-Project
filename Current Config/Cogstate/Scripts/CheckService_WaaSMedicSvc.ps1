## The following is a script to setup a scheduled task that will run a script to check for the 
## WaaSMedic Service and stop it if the service is discovered running. 

# Define Script Variables
# Path to Log File
$LogPath = "C:\Windows\Setup\Cogstate\Scripts\Logs\SchTask_log.txt"
# Define the name of the service(s)
$serviceNames = @("WaasMedicSvc", "wuauserv")

# Start transcript for detailed logging
Start-Transcript -Path $LogPath -Append

foreach ($serviceName in $serviceNames) {
    try {
        # Check if the service is running
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($null -ne $service -and $service.Status -eq 'Running') {
            # Stop the service quietly without displaying output
            Stop-Service -Name $serviceName -Force > $null
            # Confirmation Message
            Write-Host "$serviceName found running and stopped successfully." -ForegroundColor Green
        }
        else {
            Write-Host "No instances of $serviceName found running." -ForegroundColor Yellow
            }

        # Check if the service exists and try to delete it. 
        if ($null -ne $service) {
            sc.exe delete $serviceName
            # This section doesn't have a confirmation b/c 
            # that appears on screen when running sc.exe

        }
    } catch {
        Write-Host "Error occurred while stopping $serviceName $_" -ForegroundColor Red
    }
}

# Stop Transcript
Stop-Transcript

