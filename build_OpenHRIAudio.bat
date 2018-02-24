@rem ------------------------------------------------------------

set BUILD_DIR=work

@set VC_VERSION=%1
@set ARCH=%2

@if "y%ARCH%" ==  "y" (
 set ARCH=x86_64
 )
@if "y%VC_VERSION%" == "y" (
 set VC_VERSION=14
)

@rem ------------------------------------------------------------

set CMAKE_EXE="C:\Program Files\CMake\bin\cmake.exe"


set THIRD_PARTY_DIR=%~dp0..
set PORTAUDIO_DIR=%THIRD_PARTY_DIR%\portaudio
set RESAMPLE_DIR=%THIRD_PARTY_DIR%\libresample
set SPEEX_DIR=%THIRD_PARTY_DIR%\speex-1.2rc1
set SNDFILE_ROOT_DIR=C:\Program Files\Mega-Nerd\libsndfile

set OpenRTM_DIR=C:\Program Files\OpenRTM-aist\1.1.2\cmake

set HRI_ESSENTIALS_DIR=%~d0\openhrp_essentials_bin

@rem ------------------------------------------------------------
@rem Printing env variables
echo Environment variables:
echo ARCH       : %ARCH%
echo VC_VERSION : %VC_VERSION%

if %ARCH% == x86       set DLL_ARCH=
if %ARCH% == x86_64    set DLL_ARCH=_x64


@rem ============================================================
@rem  switching to x86 or x86_64
@rem ============================================================
echo ARCH %ARCH%
if %ARCH% == x86       goto cmake_x86
if %ARCH% == x86_64    goto cmake_x86_64
goto END


@rem ============================================================
@rem start to cmake 32bit 
@rem ============================================================
:cmake_x86

@rem ============================================================
@rem make work dir 
@rem ============================================================
echo work dir : work
if not exist "%BUILD_DIR%" (
	mkdir %BUILD_DIR%
) else (
	del /s /q %BUILD_DIR%
	mkdir %BUILD_DIR%
)

echo binary dir : bin
if not exist "bin" (
	mkdir bin
) else (
	del /s /q bin
	mkdir bin
)

cd %BUILD_DIR%
set VC_NAME="Visual Studio %VC_VERSION%"
%CMAKE_EXE% .. -G %VC_NAME%

goto x86

@rem ============================================================
@rem  Compiling 32bit binaries
@rem ============================================================
:x86
echo Compiling 32bit binaries
echo Setting up Visual C++ environment.

@if %VC_VERSION% == 14 (
   call C:\"Program Files (x86)"\"Microsoft Visual Studio 14.0"\VC\vcvarsall.bat x86
   set VCTOOLSET=14.0
   set PLATFORMTOOL=/p:PlatformToolset=v140
   goto MSBUILDx86
@rem   goto END
   )
@if %VC_VERSION% == 14.1 (
   call C:\"Program Files (x86)"\"Microsoft Visual Studio 14.1"\VC\vcvarsall.bat x86
   set VCTOOLSET=14.1
   set PLATFORMTOOL=/p:PlatformToolset=v141
   goto MSBUILDx86
@rem   goto END
   )

@rem ------------------------------------------------------------
@rem Build (VC2010- x86)
@rem ------------------------------------------------------------
:MSBUILDx86
echo Visual Studio Dir: %VSINSTALLDIR%
echo LIB: %LIB%
set OPT=/M:4 /toolsversion:%VCTOOLSET% %PLATFORMTOOL% /p:platform=Win32
set SLN=OpenHRIAudio.sln
set LOG=/fileLogger /flp:logfile=debug.log /v:diag 

cd %BUILD_DIR%

msbuild /t:build /p:configuration=release %OPT% %SLN%

goto CP_ESSENTIALS

:CP_ESSENTIALS
cd ..
copy %PORTAUDIO_DIR%\lib\ .\bin

@rem copy %HRI_ESSENTIALS_DIR%\*.* .\bin

goto END

@rem ============================================================
@rem start to cmake 64bit 
@rem ============================================================
:cmake_x86_64

@rem ============================================================
@rem make work dir 
@rem ============================================================
echo work dir : work
if not exist "%BUILD_DIR%" (
	mkdir %BUILD_DIR%
) else (
	del /s /q %BUILD_DIR%
	mkdir %BUILD_DIR%
)

echo binary dir : bin
if not exist "bin" (
	mkdir bin
) else (
	del /s /q bin
	mkdir bin
)

cd %BUILD_DIR%
set VC_NAME="Visual Studio %VC_VERSION% Win64"
%CMAKE_EXE% -G %VC_NAME% ..

goto x86_64

@rem ============================================================
@rem  Compiling 64bit binaries
@rem ============================================================
:x86_64
echo Compiling 64bit binaries
echo Setting up Visual C++ environment.

@if %VC_VERSION% == 14 (
   call C:\"Program Files (x86)"\"Microsoft Visual Studio 14.0"\VC\vcvarsall.bat amd64
   set VCTOOLSET=14.0
   set PLATFORMTOOL=/p:PlatformToolset=v140
   goto MSBUILDx64
   )
@if %VC_VERSION% == 14.1 (
   call C:\"Program Files (x86)"\"Microsoft Visual Studio 14.1"\VC\vcvarsall.bat amd64
   set VCTOOLSET=14.1
   set PLATFORMTOOL=/p:PlatformToolset=v141
   goto MSBUILDx64
   )

@rem ------------------------------------------------------------
@rem Build (VC2010- x86)
@rem ------------------------------------------------------------
:MSBUILDx64
echo Visual Studio Dir: %VSINSTALLDIR%
echo LIB: %LIB%
set OPT=/M:4 /toolsversion:%VCTOOLSET% %PLATFORMTOOL% /p:platform=x64
set SLN=OpenHRIAudio.sln
set LOG=/fileLogger /flp:logfile=debug.log /v:diag 

cd %BUILD_DIR%

msbuild /t:build /p:configuration=release %OPT% %SLN%

goto CP_ESSENTIALS

:CP_ESSENTIALS
cd ..
@rem copy %PORTAUDIO_DIR%\lib\ .\bin

copy %HRI_ESSENTIALS_DIR%\*.* .\bin

goto END

:END
echo "Finished"
