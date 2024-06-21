## The following script checks the Windows directory for instances of the WaaSMedicAgent.exe and then deletes them. 

# Define script variables
$directory = "C:\"
$fileName = "WaaSMedicAgent.exe"
#$adminAccount = [System.Security.Principal.NTAccount]".\Cogstate Admin"
$adminAccount = [System.Security.Principal.NTAccount]"BUILTIN\Administrators"
$logFile = "C:\Windows\Setup\Cogstate\Scripts\Logs\FindWaaS_log.txt"


# Start transcript for detailed logging
Start-Transcript -Path $logFile -Append

# Search the directory for the specified file
$files = Get-ChildItem -Path $directory -Filter $fileName -Recurse -ErrorAction SilentlyContinue

# Check if files were found
if ($files) {
    # Iterate
    foreach ($file in $files) {
        try {
            # Change owner
            $acl = Get-Acl $file.FullName
            $acl.SetOwner($adminAccount)
            Set-Acl $file.FullName $acl

            # Change ACL 
            $permission = $adminAccount,"FullControl","Allow"
            $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
            $acl.SetAccessRule($rule)
            Set-Acl $file.FullName $acl

            # Delete file
            Remove-Item $file.FullName -Force

            Write-Host "Deleted $($file.FullName)" -ForegroundColor Magenta 
                    }
        catch {
            Write-Host "Failed to delete $($file.FullName)" -ForegroundColor Red
                    }
    }

    # Tell me what was deleted and from where
    Write-Host "All instances of $fileName deleted from $directory." -ForegroundColor Green
}
else {
    Write-Host "No instances of $fileName found in $directory." -ForegroundColor Yellow
}

# Stop transcript
Stop-Transcript