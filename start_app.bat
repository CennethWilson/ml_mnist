@echo off
cd /d %~dp0

netstat -ano | find ":5000" > nul
if errorlevel 1 (
    start "" /B backend.exe
)

:waitloop
powershell -Command "try { $r = Invoke-WebRequest -Uri http://127.0.0.1:5000/ping -UseBasicParsing; exit 0 } catch { exit 1 }"
if errorlevel 1 (
    timeout /t 1 > nul
    goto waitloop
)

start "" /WAIT ML_mnist.exe

taskkill /F /IM backend.exe ? nul 2>&1