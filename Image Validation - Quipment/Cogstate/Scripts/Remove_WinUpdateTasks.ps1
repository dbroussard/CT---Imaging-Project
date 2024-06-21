# Define Script Variables
$directory = "C:\Windows\System32\Tasks\Microsoft\Windows"
$folderNames = @("WindowsUpdate", "WaaSMedic", "UpdateOrchestrator")
$adminAccount = [System.Security.Principal.NTAccount]".\Cogstate Admin"
#$adminAccount = [System.Security.Principal.NTAccount]"BUILTIN\Administrators"
$logFile = "C:\Windows\Cogstate\Scripts\Logs\RemoveUpdateTasks_Log.txt"

# Start transcript for detailed logging
Start-Transcript -Path $logFile -Append

# Seek and Destroy
foreach ($folderName in $folderNames) {
    $folderPath = Join-Path -Path $directory -ChildPath $folderName

    if (Test-Path $folderPath) {
        try {
            # Change owner of the folder and its contents to local computer admin account
            takeown /F $folderPath /R /D Y
            icacls $folderPath /grant administrators:F /T

            # Delete the folder and its contents
            Remove-Item $folderPath -Recurse -Force

            Write-Host "Deleted $folderPath"
            
        }
        catch {
            Write-Host "Failed to delete $folderPath" -ForegroundColor Red
            
        }
    } else {
        Write-Host "Folder $folderName not found." -ForegroundColor Magenta
        
    }
}

Write-Host "All specified folders deleted from $directory." -ForegroundColor Green


# Stop transcript
Stop-Transcript
