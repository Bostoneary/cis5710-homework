@echo off
REM Avoid recursion problems by not explicitly using setlocal/endlocal

if "%~1"=="" (
    echo Usage: %~nx0 [start^|stop]
    exit /b 1
)

if /i "%~1"=="start" (
    echo Starting container MY-CIS5710...
    docker start MY-CIS5710
    if %ERRORLEVEL% neq 0 (
        echo Failed to start container!
        exit /b %ERRORLEVEL%
    )
    echo Attaching to the container shell...
    docker exec -it MY-CIS5710 /bin/bash
) else if /i "%~1"=="stop" (
    echo Stopping container MY-CIS5710...
    docker stop MY-CIS5710
) else (
    echo Invaild Parameter: %~1
    echo Avaliable Parameter: start, stop
    exit /b 1
)