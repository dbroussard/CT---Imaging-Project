@echo off
setlocal

REM Prompt the user if they want to proceed with the script
set /p "confirm=Do you want to proceed with the Cogstate Image Validation? (Y/N): "
if /i "%confirm%" NEQ "Y" (
    echo Aborting script.
    exit /b
)

REM Check and create Cogstate directory
if not exist "C:\Windows\Cogstate" (
    set /p "confirm=Cogstate directory does not exist. Create it? (Y/N): "
    if /i "%confirm%" EQU "Y" (
        mkdir "C:\Windows\Cogstate"
        echo Cogstate directory created
    ) else (
        echo Aborting setup. Cogstate directory not created.
        exit /b
    )
) else (
    echo Cogstate directory already exists
)

REM Check and create Logs directory within Cogstate
if not exist "C:\Windows\Cogstate\Scripts\Logs" (
    set /p "confirm=Logs directory does not exist within Cogstate. Create it? (Y/N): "
    if /i "%confirm%" EQU "Y" (
        mkdir "C:\Windows\Cogstate\Scripts\Logs"
        echo Logs directory created within Cogstate
    ) else (
        echo Aborting setup. Logs directory not created.
        exit /b
    )
) else (
    echo Logs directory already exists within Cogstate
)

REM Prompt to continue with copying assets
set /p "confirm=Do you want to copy Cogstate Asset files? (Y/N): "
if /i "%confirm%" EQU "Y" (
    xcopy "D:\Cogstate" "C:\Windows\Cogstate" /E /H
    xcopy "D:\Cogstate\Assets\grouppolicy" "C:\Windows\System32\groupPolicy" /E /H
    echo Cogstate Assets imported successfully
) else (
    echo Skipping copying Cogstate Assets.
)

REM Prompt to continue with applying security and audit definitions
set /p "confirm=Do you want to apply Security and Audit Definitions? (Y/N): "
if /i "%confirm%" EQU "Y" (
    Secedit /configure /cfg "D:\Cogstate\Assets\Security.csv" /db defltbase.sdb /verbose
    Auditpol /restore /file:"D:\Cogstate\Assets\Audit.ini"
    echo Cogstate Security and Audit Definitions applied
) else (
    echo Skipping applying Security and Audit Definitions.
)

REM Prompt to continue with executing PowerShell scripts
set /p "confirm=Do you want to execute PowerShell scripts to Halt Windows Updates? (Y/N): "
if /i "%confirm%" EQU "Y" (
    powershell.exe -ExecutionPolicy Bypass -File "C:\Windows\Cogstate\Scripts\CheckService_WaaSMedicSvc.ps1"
    sc delete wuauserv
    powershell.exe -ExecutionPolicy Bypass -File "C:\Windows\Cogstate\Scripts\FindFile_WaaSMedic.ps1"
    powershell.exe -ExecutionPolicy Bypass -File "C:\Windows\Cogstate\Scripts\Remove_WinUpdateTasks.ps1"
    powershell.exe -ExecutionPolicy Bypass -File "C:\Windows\Cogstate\Scripts\SchdTask_RemoveWinUpdateTasks.ps1"
    echo PowerShell scripts executed
) else (
    echo Skipping executing PowerShell scripts.
)

REM Prompt to run the new Scheduled Task
set /p "confirm=Do you want to run the scheduled task to halt Windows Updates? (Y/N): "
if /i "%confirm%" EQU "Y" (
    schtasks /run /tn "CheckService_WaaSMedicSvc"
) else (
    echo Skipping running the new Scheduled Task.
)

echo All operations completed.
