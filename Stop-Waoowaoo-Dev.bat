@echo off
setlocal EnableDelayedExpansion

set "ROOT=%~dp0"
cd /d "%ROOT%"

set "DOCKER_CONFIG=%ROOT%.dockerconfig"
set "RUN_DIR=%ROOT%.run"
set "PID_FILE=%RUN_DIR%\dev-server.pid"
set "APP_CONTAINER=waoowaoo-app"
set "MYSQL_CONTAINER=waoowaoo-mysql"
set "REDIS_CONTAINER=waoowaoo-redis"
set "MINIO_CONTAINER=waoowaoo-minio"

if exist "%PID_FILE%" (
  set /p DEV_PID=<"%PID_FILE%"
  if defined DEV_PID (
    echo [1/3] Stopping dev process tree PID !DEV_PID!...
    taskkill /F /T /PID !DEV_PID! >nul 2>&1
  )
  del /f /q "%PID_FILE%" >nul 2>&1
) else (
  echo [1/3] No PID file found. Scanning for leftover repo processes...
)

for /f %%P in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$root = (Resolve-Path '.').Path; $set = New-Object 'System.Collections.Generic.HashSet[int]'; foreach ($proc in Get-CimInstance Win32_Process) { if ($proc.CommandLine -and $proc.CommandLine -like ('*' + $root + '*') -and ($proc.CommandLine -like '*npm.cmd*run dev*' -or $proc.CommandLine -like '*npm-cli.js*run dev*' -or $proc.CommandLine -like '*concurrently*' -or $proc.CommandLine -like '*next*dev*' -or $proc.CommandLine -like '*start-server.js*' -or $proc.CommandLine -like '*tsx*watch*--env-file=.env*')) { [void]$set.Add([int]$proc.ProcessId) } }; foreach ($procId in $set) { Write-Output $procId }"') do (
  taskkill /F /T /PID %%P >nul 2>&1
)

echo [2/3] Stopping Docker services...
call :stop_container "%APP_CONTAINER%" "app"
call :stop_container "%MINIO_CONTAINER%" "minio"
call :stop_container "%MYSQL_CONTAINER%" "mysql"
call :stop_container "%REDIS_CONTAINER%" "redis"

if exist "%PID_FILE%" del /f /q "%PID_FILE%" >nul 2>&1

echo [3/3] Done.
exit /b 0

:stop_container
set "CONTAINER_NAME=%~1"
set "SERVICE_NAME=%~2"
set "CONTAINER_RUNNING="

for /f %%R in ('docker inspect -f "{{.State.Running}}" "%CONTAINER_NAME%" 2^>nul') do set "CONTAINER_RUNNING=%%R"
if /i "%CONTAINER_RUNNING%"=="true" (
  echo [INFO] Stopping %SERVICE_NAME% container: %CONTAINER_NAME%
  docker stop "%CONTAINER_NAME%" >nul
  exit /b 0
)

if /i "%CONTAINER_RUNNING%"=="false" (
  echo [INFO] %SERVICE_NAME% container already exists but is stopped: %CONTAINER_NAME%
  exit /b 0
)

echo [INFO] %SERVICE_NAME% container not found: %CONTAINER_NAME%
exit /b 0
