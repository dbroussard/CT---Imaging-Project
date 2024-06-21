@echo off
setlocal

set "desktop=%USERPROFILE%\Desktop"
set "shortcutName=Microsoft Edge.lnk"

if exist "%desktop%\%shortcutName%" (
    del "%desktop%\%shortcutName%"
    echo Edge shortcut deleted successfully.
) else (
    echo Edge shortcut not found on the desktop.
)

endlocal
