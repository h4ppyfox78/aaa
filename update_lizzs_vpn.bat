@echo off
setlocal

:: Set variables
set "TUNNEL_NAME=Lizzs vpn"
set "CONFIG_URL=https://raw.githubusercontent.com/h4ppyfox78/aaa/refs/heads/main/Lizzs-vpn(4).conf"
set "TEMP_CONF=%TEMP%\lizzs_vpn.conf"

echo Downloading new configuration...
powershell -Command "Invoke-WebRequest -Uri '%CONFIG_URL%' -OutFile '%TEMP_CONF%'"

if exist "%TEMP_CONF%" (
    echo Checking for existing tunnel: %TUNNEL_NAME%
    powershell -Command "if (Get-Command 'wireguard' -ErrorAction SilentlyContinue) { Start-Process 'wireguard' -ArgumentList '/uninstalltunnel=\"%TUNNEL_NAME%\"' -Wait }"

    echo Importing new configuration as tunnel: %TUNNEL_NAME%
    Start-Process "wireguard" -ArgumentList "/importtunnel=%TEMP_CONF%" -Wait

    echo Done.
) else (
    echo Failed to download configuration.
)

:: Clean up
del "%TEMP_CONF%" >nul 2>&1

endlocal
pause
