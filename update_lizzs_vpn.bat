@echo off
setlocal

:: Set variables
set "TUNNEL_NAME=Lizzs vpn"
set "CONFIG_URL=http://sponsored-cash.gl.at.ply.gg:65433/api/wireguard/client/64489ae1-9d41-4f26-bbe5-a154fae36989/configuration"
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
