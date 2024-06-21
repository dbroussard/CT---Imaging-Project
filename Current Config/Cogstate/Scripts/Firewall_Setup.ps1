## The following script sets up the Cogstate Device Firewall.

# Define Script Variables
$logFile = "C:\Windows\Setup\Cogstate\Scripts\Logs\FirewallSetup_Log.txt"

# Start transcript for detailed logging
Start-Transcript -Path $logFile -Append

try {
    ## Set the default policy to block
    Set-NetFirewallProfile -Profile Domain -Enabled False | Out-Null
    Set-NetFirewallProfile -Name Private -Enabled False | Out-Null
    Set-NetFirewallProfile -Name Public -Enabled True | Out-Null
    Set-NetFirewallProfile -Name Public -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen False -AllowUnicastResponseToMulticast False -LogFileName %SystemRoot%\System32\LogFiles\Firewall\pfirewall.log | Out-Null

    ## Allow inbound and outbound on HTTP and HTTPS ports
    New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 80 | Out-Null
    New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Outbound -Action Allow -Protocol TCP -LocalPort 80 | Out-Null
    New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 443 | Out-Null
    New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Outbound -Action Allow -Protocol TCP -LocalPort 443 | Out-Null

    ## List of applications for RMM
    $applications = @(
        "C:\Program Files\ATERA Networks\AteraAgent\AteraAgent.exe",
        "C:\Program Files (x86)\Splashtop\Splashtop Remote\Server\SRManager.exe",
        "C:\Program Files\ATERA Networks\AteraAgent\Packages\AgentPackageRemoteDiagnostics\AgentPackageRemoteDiagnostics.Sessions.exe",
        "C:\Program Files (x86)\Splashtop\Splashtop Remote\Server\SRFeature.exe",
        "C:\Program Files (x86)\Splashtop\Splashtop Remote\Server\SRApp.exe",
        "C:\Program Files\ATERA Networks\AteraAgent\Packages\AgentPackageRunCommandInteractive\AgentPackageRunCommandInteractive.exe",
        "C:\Program Files\ATERA Networks\AteraAgent\Packages\Agent.Package.Availability\Agent.Package.Availability.exe"
    )

    foreach ($app in $applications) {
        $appName = Split-Path $app -Leaf
        New-NetFirewallRule -DisplayName "Allow $appName Inbound" -Direction Inbound -Program $app -Action Allow | Out-Null
        New-NetFirewallRule -DisplayName "Allow $appName Outbound" -Direction Outbound -Program $app -Action Allow | Out-Null
    }

    ## Allow Chrome to connect over the network
    New-NetFirewallRule -DisplayName "Allow Chrome" -Direction Outbound -Program "C:\Program Files\Google\Chrome\Application\chrome.exe" -Action Allow | Out-Null

    # Logging blocked connections for troubleshooting
    Set-NetFirewallProfile -Profile Domain,Public,Private -LogBlocked True | Out-Null

    # Confirmation Message
    Write-Host "Firewall Setup Complete, please see log for details" -ForegroundColor Green
} catch {
    Write-Host "Error occurred: $_" -ForegroundColor Red
}

# Stop transcript
Stop-Transcript 
