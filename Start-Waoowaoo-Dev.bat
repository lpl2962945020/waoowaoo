@echo off
setlocal EnableDelayedExpansion

set "ROOT=%~dp0"
cd /d "%ROOT%"

set "DOCKER_CONFIG=%ROOT%.dockerconfig"
set "npm_config_cache=%ROOT%.npm-cache"
set "RUN_DIR=%ROOT%.run"
set "LOG_DIR=%ROOT%logs"
set "PID_FILE=%RUN_DIR%\dev-server.pid"
set "OUT_LOG=%LOG_DIR%\dev-server.log"
set "ERR_LOG=%LOG_DIR%\dev-server.err.log"
set "FRONTEND_URL=http://127.0.0.1:3000"
set "MYSQL_CONTAINER=waoowaoo-mysql"
set "REDIS_CONTAINER=waoowaoo-redis"

if not exist "%ROOT%.env" (
  echo [ERROR] Missing .env in "%ROOT%".
  pause
  exit /b 1
)

if not exist "%DOCKER_CONFIG%" mkdir "%DOCKER_CONFIG%" >nul 2>&1
if not exist "%RUN_DIR%" mkdir "%RUN_DIR%" >nul 2>&1
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1

echo [1/4] Starting Docker services: MySQL and Redis...
call :ensure_container "%MYSQL_CONTAINER%" "mysql"
if errorlevel 1 (
  echo [ERROR] Failed to prepare MySQL container.
  pause
  exit /b 1
)
call :ensure_container "%REDIS_CONTAINER%" "redis"
if errorlevel 1 (
  echo [ERROR] Failed to prepare Redis container.
  pause
  exit /b 1
)

if exist "%PID_FILE%" (
  set /p EXISTING_PID=<"%PID_FILE%"
  if defined EXISTING_PID (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Get-Process -Id !EXISTING_PID! -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }"
    if not errorlevel 1 (
      echo [2/4] Dev server is already running with PID !EXISTING_PID!.
      start "" "%FRONTEND_URL%"
      exit /b 0
    )
  )
  del /f /q "%PID_FILE%" >nul 2>&1
)

set "PORT3000_PID="
for /f %%P in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$conn = Get-NetTCPConnection -LocalPort 3000 -State Listen -ErrorAction SilentlyContinue; if ($conn) { $first = @($conn)[0]; Write-Output $first.OwningProcess }"') do set "PORT3000_PID=%%P"
if defined PORT3000_PID (
  echo [ERROR] Port 3000 is in use by PID !PORT3000_PID!.
  echo Run Stop-Waoowaoo-Dev.bat first if that is an old project instance.
  pause
  exit /b 1
)

if not exist "%ROOT%node_modules\.bin\tsx.cmd" (
  echo [SETUP] node_modules not found. Running npm install for first-time setup...
  call npm.cmd install
  if errorlevel 1 (
    echo [ERROR] npm install failed.
    pause
    exit /b 1
  )
)

type nul > "%OUT_LOG%"
type nul > "%ERR_LOG%"

echo [2/4] Starting local dev server in the background...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$root = (Resolve-Path '.').Path; $out = Join-Path $root 'logs\dev-server.log'; $err = Join-Path $root 'logs\dev-server.err.log'; $pidFile = Join-Path $root '.run\dev-server.pid'; $p = Start-Process -FilePath 'cmd.exe' -ArgumentList '/c','npm.cmd run dev' -WorkingDirectory $root -RedirectStandardOutput $out -RedirectStandardError $err -WindowStyle Hidden -PassThru; Set-Content -Path $pidFile -Value $p.Id -Encoding ascii"
if errorlevel 1 (
  echo [ERROR] Failed to start the local dev server.
  pause
  exit /b 1
)

echo [3/4] Waiting for %FRONTEND_URL% ...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$url = 'http://127.0.0.1:3000'; $ready = $false; for ($i = 0; $i -lt 90; $i++) { try { $resp = Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 2; if ($resp.StatusCode -ge 200) { $ready = $true; break } } catch {}; Start-Sleep -Seconds 1 }; if ($ready) { exit 0 } else { exit 1 }"
if errorlevel 1 (
  echo [ERROR] Dev server did not become ready in time.
  echo Check "%OUT_LOG%" and "%ERR_LOG%".
  pause
  exit /b 1
)

echo [4/4] Opening frontend page...
start "" "%FRONTEND_URL%"

echo [DONE] Waoowaoo local dev is running.
echo Frontend: %FRONTEND_URL%
echo Logs: %OUT_LOG%
exit /b 0

:ensure_container
set "CONTAINER_NAME=%~1"
set "SERVICE_NAME=%~2"
set "CONTAINER_RUNNING="

for /f %%R in ('docker inspect -f "{{.State.Running}}" "%CONTAINER_NAME%" 2^>nul') do set "CONTAINER_RUNNING=%%R"
if defined CONTAINER_RUNNING (
  if /i "!CONTAINER_RUNNING!"=="true" (
    echo [OK] %SERVICE_NAME% container is already running: %CONTAINER_NAME%
    exit /b 0
  )
  echo [INFO] Starting existing %SERVICE_NAME% container: %CONTAINER_NAME%
  docker start "%CONTAINER_NAME%" >nul
  if errorlevel 1 exit /b 1
  exit /b 0
)

echo [INFO] Creating %SERVICE_NAME% container with Docker Compose...
docker compose up %SERVICE_NAME% -d
if errorlevel 1 exit /b 1
exit /b 0
