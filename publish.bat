@echo off
goto:$main

:command
setlocal EnableDelayedExpansion
    set "_command=%*"
    set "_command=!_command:   = !"
    set "_command=!_command:  = !"
    set "_command=!_command:  = !"
    echo ##[cmd] !_command!
    call !_command!
endlocal & exit /b %errorlevel%

:log
setlocal EnableDelayedExpansion
    set "_log=%~1"
    shift
    set "_command=%1 %2 %3 %4 %5 %6 %7 %8 %9"
    set "_command=!_command:   = !"
    set "_command=!_command:  = !"
    echo ##[cmd] !_command!
    call !_command! >"!_log!" 2>&1
    call !_command!
exit /b %errorlevel%

:build
    set "root=%~dp1"
    if "%root:~-1%"=="\" set "root=%root:~0,-1%"
    if not exist "%root%\.build" mkdir "%root%\.build"
    call :vsdev devenv "%root%\source\BulkCrapUninstaller.sln" /Build
    call :vsdev msbuild /m /t:Rebuild /p:Configuration^="Release" /p:Platform^="x64" "%root%\BulkCrapUninstaller.sln"
exit /b %errorlevel%

:set_error
setlocal
    set _error=%~1
endlocal & exit /b %_error%

:vsdev_cmd
setlocal EnableDelayedExpansion
    set "_command=%*"
    set "_command=!_command:   = !"
    set "_command=!_command:  = !"
    echo ##[cmd] !_command!
    call !_command!
endlocal & (
    set "__COMPAT_LAYER=%__COMPAT_LAYER%"
    set "__CONDA_OPENSLL_CERT_FILE_SET=%__CONDA_OPENSLL_CERT_FILE_SET%"
    set "__DOTNET_ADD_32BIT=%__DOTNET_ADD_32BIT%"
    set "__DOTNET_PREFERRED_BITNESS=%__DOTNET_PREFERRED_BITNESS%"
    set "__VCVARS_REDIST_VERSION=%__VCVARS_REDIST_VERSION%"
    set "__VSCMD_PREINIT_PATH=%__VSCMD_PREINIT_PATH%"
    set "DriverData=%DriverData%"
    set "ExtensionSdkDir=%ExtensionSdkDir%"
    set "EXTERNAL_INCLUDE=%EXTERNAL_INCLUDE%"
    set "FPS_BROWSER_APP_PROFILE_STRING=%FPS_BROWSER_APP_PROFILE_STRING%"
    set "FPS_BROWSER_USER_PROFILE_STRING=%FPS_BROWSER_USER_PROFILE_STRING%"
    set "Framework40Version=%Framework40Version%"
    set "FrameworkDir=%FrameworkDir%"
    set "FrameworkDir32=%FrameworkDir32%"
    set "FrameworkVersion=%FrameworkVersion%"
    set "FrameworkVersion32=%FrameworkVersion32%"
    set "FSHARPINSTALLDIR=%FSHARPINSTALLDIR%"
    set "NETFXSDKDir=%NETFXSDKDir%"
    set "PATH=%PATH%"
    set "PATHEXT=%PATHEXT%"
    set "QtMsBuild=%QtMsBuild%"
    set "SESSIONNAME=%SESSIONNAME%"
    set "SystemDrive=%SystemDrive%"
    set "SystemRoot=%SystemRoot%"
    set "UATDATA=%UATDATA%"
    set "UCRTVersion=%UCRTVersion%"
    set "UniversalCRTSdkDir=%UniversalCRTSdkDir%"
    set "VCIDEInstallDir=%VCIDEInstallDir%"
    set "VCINSTALLDIR=%VCINSTALLDIR%"
    set "VCPKG_ROOT=%VCPKG_ROOT%"
    set "VCToolsInstallDir=%VCToolsInstallDir%"
    set "VCToolsRedistDir=%VCToolsRedistDir%"
    set "VCToolsVersion=%VCToolsVersion%"
    set "VisualStudioVersion=%VisualStudioVersion%"
    set "VS170COMNTOOLS=%VS170COMNTOOLS%"
    set "VSCMD_ARG_app_plat=%VSCMD_ARG_app_plat%"
    set "VSCMD_ARG_HOST_ARCH=%VSCMD_ARG_HOST_ARCH%"
    set "VSCMD_ARG_TGT_ARCH=%VSCMD_ARG_TGT_ARCH%"
    set "VSCMD_DEBUG=%VSCMD_DEBUG%"
    set "VSCMD_VER=%VSCMD_VER%"
    set "VSINSTALLDIR=%VSINSTALLDIR%"
    set "VSSDK150INSTALL=%VSSDK150INSTALL%"
    set "VSSDKINSTALL=%VSSDKINSTALL%"
    set "WindowsLibPath=%WindowsLibPath%"
    set "WindowsSDK_ExecutablePath_x64=%WindowsSDK_ExecutablePath_x64%"
    set "WindowsSDK_ExecutablePath_x86=%WindowsSDK_ExecutablePath_x86%"
    set "WindowsSdkBinPath=%WindowsSdkBinPath%"
    set "WindowsSdkDir=%WindowsSdkDir%"
    set "WindowsSDKLibVersion=%WindowsSDKLibVersion%"
    set "WindowsSdkVerBinPath=%WindowsSdkVerBinPath%"
    set "WindowsSDKVersion=%WindowsSDKVersion%"
    exit /b %errorlevel%
)

:vsdev
setlocal EnableDelayedExpansion
    :: Assume build environment is already setup if msbuild can be located
    where msbuild >nul 2>nul && goto:$vsdev_main_command

    :: Allow the path to vsdevcmd to be provided by our caller
    if exist "%vsdevcmd%" (
        goto:$launch_dev_cmd
    )
    :: If we're still running, must be no vsdevcmd

    if "%ProgramFiles(x86)%"=="" set ProgramFiles(x86)=%ProgramFiles%
    set vswhere="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
    if not exist %vswhere% (
        echo [ERROR] vswhere.exe not found; unable to locate build tools.
        call :set_error 81
        goto:$vsdev_done
    )

    :: This should work for Visual Studio
    for /f "usebackq delims=" %%i in (`%vswhere% -latest -requires Microsoft.VisualStudio.Workload.NativeDesktop -find *\Tools\vsdevcmd.bat`) do (
        set "vsdevcmd=%%i"
        goto:$launch_dev_cmd
    )

    :: This should work with Visual Studio Build Tools
    for /f "usebackq delims=" %%i in (`%vswhere% -latest -products * -requires Microsoft.VisualStudio.Workload.VCTools -find *\Tools\vsdevcmd.bat`) do (
        set "vsdevcmd=%%i"
        goto:$launch_dev_cmd
    )

    :: As a last resort, try without specifying the required workload
    for /f "usebackq delims=" %%i in (`%vswhere% -latest -products * -find *\Tools\vsdevcmd.bat`) do (
        set "vsdevcmd=%%i"
        goto:$launch_dev_cmd
    )

    :: If we're still running, vsdevcmd wasn't executed
    echo [ERROR] Unable to locate build tools.
    call :set_error 80
    goto:$vsdev_done

    :$launch_dev_cmd
        set VSCMD_DEBUG=2
        echo Found Visual Studio build tools: "%vsdevcmd%"
        call :vsdev_cmd "%vsdevcmd%"
        goto:$vsdev_main_command

    :$vsdev_main_command
        if "%~1"=="" goto:$vsdev_done
        call :vsdev_cmd %*
        goto:$vsdev_done

    :$vsdev_done
        set "RETURN_VALUE=%ERRORLEVEL%"
endlocal & (
    set "PATH=%PATH%"
    exit /b %RETURN_VALUE%
)

:publish
    setlocal
    set "identifier=win-%platform%"
    set "target=%~dp0bin\publish\%identifier%"

    call :command "%msbuild%" "%~dp0source\BulkCrapUninstaller.sln" ^
        /m /p:filealignment=512 ^
        /t:Restore;Rebuild ^
        /p:DeployOnBuild=True ^
        /p:PublishSingleFile=False ^
        /p:SelfContained=True ^
        /p:PublishProtocol=FileSystem ^
        /p:Configuration=%config% ^
        /p:Platform=%platform% ^
        /p:TargetFrameworks="net6.0-windows10.0.18362.0" ^
        /p:PublishDir="%target%" ^
        /p:RuntimeIdentifier="%identifier%" ^
        /p:PublishReadyToRun=false ^
        /p:PublishTrimmed=False ^
        /verbosity:minimal
    if errorlevel 1 goto:$publish_end

    call :command "%msbuild%" "%~dp0source\BulkCrapUninstaller.sln" ^
        /m /p:filealignment=512 ^
        /t:Publish ^
        /p:DeployOnBuild=True ^
        /p:PublishSingleFile=False ^
        /p:SelfContained=True ^
        /p:PublishProtocol=FileSystem ^
        /p:Configuration=%config% ^
        /p:Platform=%platform% ^
        /p:TargetFrameworks="net6.0-windows10.0.18362.0" ^
        /p:PublishDir="%target%" ^
        /p:RuntimeIdentifier="%identifier%" ^
        /p:PublishReadyToRun=false ^
        /p:PublishTrimmed=False ^
        /verbosity:minimal
    if errorlevel 1 goto:$publish_end

   :$publish_end
exit /b %errorlevel%

:$main
setlocal EnableDelayedExpansion
    cd /d "%~dp0"

    :: Configuration is either 'Release' or 'Debug'
    set "config=Release"
    set "msbuild=D:\Applications\VS2022\MSBuild\Current\Bin\amd64\MSBuild.exe"
    if exist "!msbuild!" goto:$build
    set "msbuild=C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe"
    if exist "!msbuild!" goto:$build
    set "msbuild=C:\Program Files\Microsoft Visual Studio\2022\Community\Msbuild\Current\Bin\MSBuild.exe"
    if exist "!msbuild!" goto:$build
    set "msbuild=C:\Program Files\Microsoft Visual Studio\2022\Community\Msbuild\Current\Bin\amd64\MSBuild.exe"
    if exist "!msbuild!" goto:$build
    set "msbuild=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
    if exist "!msbuild!" goto:$build
    set "msbuild=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\amd64\MSBuild.exe"
    if exist "!msbuild!" goto:$build
    echo [ERROR] MSBuild not found; unable to build.
    goto:$done

    :$build
    echo Using MSBuild: "!msbuild!"
    set "publish=%~dp0bin\publish"

    if exist "%publish%" rmdir /q /s "%publish%"
    if errorlevel 1 (echo [WARNING] Failed to cleanup existing publish directory: "%publish%")
    if exist "%~dp0bin\launcher" rmdir /q /s "%~dp0bin\launcher"
    if errorlevel 1 (echo [WARNING] Failed to cleanup existing launcher directory: "%~dp0bin\launcher")

    call :build "%~dp0\"

    set "platform=x64"
    call :publish

    set "platform=x86"
    call :publish

    if exist "%~dp0bin\launcher\BCU-launcher.exe" (
        copy "%~dp0bin\launcher\BCU-launcher.exe" "%publish%\BCUninstaller.exe"
    )
    if exist "%target%\BCU_manual.html" (
        copy "%target%\BCU_manual.html" "%publish%\BCU_manual.html"
    )
    if exist "%target%\LICENSE" (
        copy "%target%\LICENSE" "%publish%\LICENSE"
    )
    if exist "%target%\PrivacyPolicy.txt" (
        copy "%target%\PrivacyPolicy.txt" "%publish%\PrivacyPolicy.txt"
    )

    if exist "%~dp0bin\launcher" rmdir /q /s "%~dp0bin\launcher"
    if "%config%"=="Release" goto:$release
    goto:$done

    :$release
    if exist "%publish%" del /f /s /q "%publish%\*.pdb"
    goto:$done

    :$done
    echo Publish process complete. Return code: '%errorlevel%'
endlocal & exit /b %errorlevel%
