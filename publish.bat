@echo off
setlocal EnableDelayedExpansion
    cd /d "%~dp0"

    :: Configuration is either 'Release' or 'Debug'
    set "config=Release"
    set "msbuild=D:\Applications\VS2022\MSBuild\Current\Bin\amd64\MSBuild.exe"
    if not exist "!msbuild!" set "msbuild=C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe"
    if not exist "!msbuild!" set "msbuild=C:\Program Files\Microsoft Visual Studio\2022\Community\Msbuild\Current\Bin\MSBuild.exe"
    if not exist "!msbuild!" set "msbuild=C:\Program Files\Microsoft Visual Studio\2022\Community\Msbuild\Current\Bin\amd64\MSBuild.exe"
    if not exist "!msbuild!" set "msbuild=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
    if not exist "!msbuild!" set "msbuild=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\amd64\MSBuild.exe"
    set "publish=%~dp0bin\publish"

    if exist "%publish%" rmdir /q /s "%publish%"
    if errorlevel 1 (pause)
    if exist "%~dp0bin\launcher" rmdir /q /s "%~dp0bin\launcher"
    if errorlevel 1 (pause)

    set "platform=x64"
    call :publish

    set "platform=x86"
    call :publish

    copy "%~dp0bin\launcher\BCU-launcher.exe" "%publish%\BCUninstaller.exe"
    copy "%target%\BCU_manual.html" "%publish%\BCU_manual.html"
    copy "%target%\LICENSE" "%publish%\LICENSE"
    copy "%target%\PrivacyPolicy.txt" "%publish%\PrivacyPolicy.txt"

    rmdir /q /s "%~dp0bin\launcher"
    if "%config%"=="Release" (
        del /f /s /q "%publish%\*.pdb"
    )
    pause
exit /b 0

:publish
    setlocal
    set "identifier=win-%platform%"
    set "target=%~dp0bin\publish\%identifier%"

    "%msbuild%" "%~dp0source\BulkCrapUninstaller.sln" ^
        /m /p:filealignment=512 ^
        /t:Restore;Rebuild ^
        /p:DeployOnBuild=true ^
        /p:PublishSingleFile=False ^
        /p:SelfContained=True ^
        /p:PublishProtocol=FileSystem ^
        /p:Configuration=%config% ^
        /p:Platform=%platform% ^
        /p:TargetFrameworks="net6.0-windows10.0.18362.0" ^
        /p:PublishDir="%target%" ^
        /p:RuntimeIdentifier=%identifier% ^
        /p:PublishReadyToRun=false ^
        /p:PublishTrimmed=False ^
        /verbosity:minimal

    "%msbuild%" "%~dp0source\BulkCrapUninstaller.sln" ^
        /m /p:filealignment=512 ^
        /t:Publish ^
        /p:DeployOnBuild=true ^
        /p:PublishSingleFile=False ^
        /p:SelfContained=True ^
        /p:PublishProtocol=FileSystem ^
        /p:Configuration=%config% ^
        /p:Platform=%platform% ^
        /p:TargetFrameworks="net6.0-windows10.0.18362.0" ^
        /p:PublishDir="%target%" ^
        /p:RuntimeIdentifier=%identifier% ^
        /p:PublishReadyToRun=false ^
        /p:PublishTrimmed=False ^
        /verbosity:minimal
goto :eof
