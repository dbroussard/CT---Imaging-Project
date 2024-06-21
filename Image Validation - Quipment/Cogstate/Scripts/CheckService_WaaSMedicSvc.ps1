##The following script will be used for a a scheduled task to check if the WaaSMedic or WauServ Service is running and stop the service.

# Define an array of service names to check and stop
$serviceNames = @("WaasMedicSvc", "Wuauserv")

# Iterate through each service name
foreach ($serviceName in $serviceNames) {
    # Check if the service is running
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

    if ($service -ne $null -and $service.Status -eq 'Running') {
        # Stop the service quietly without displaying output
        Stop-Service -Name $serviceName -Force > $null
        Write-Output "Stopped service: $serviceName"	
    } else {
        Write-Output "Service is not running or not found: $serviceName"
    }
}

