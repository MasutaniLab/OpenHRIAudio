@rem ソースファイルディレクトリ、VCのバージョンを設定する。
set PORTAUDIO_ROOT=portaudio
set BUILD_DIR=work
set PATH_ORG=%PATH%

@rem お使いの環境に合わせてアーキテクチャを修正します。
set ARCH=x86_64

@rem お使いのVisual studio のversion に合わせて修正します。
set VC_VERSION=14

@rem お使いのCMakeのversionに合わせて修正します。
set PATH=%PATH%;C:\"Program Files"\"CMake"\bin;

if %ARCH% ==              set ARCH=x86
if %VC_VERSION% ==        set VC_VERSION=10

@rem ------------------------------------------------------------
@rem Printing env variables
echo Environment variables:
echo ARCH       : %ARCH%
echo VC_VERSION : %VC_VERSION%

if %ARCH% == x86       set DLL_ARCH=
if %ARCH% == x86_64    set DLL_ARCH=_x64

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
cd %BUILD_DIR%
set VC_NAME="Visual Studio %VC_VERSION%"
cmake .. -G %VC_NAME%
goto x86

@rem ============================================================
@rem  Compiling 32bit binaries
@rem ============================================================
:x86
echo Compiling 32bit binaries
echo Setting up Visual C++ environment.
if %VC_VERSION% == 10 (
@rem   call C:\"Program Files (x86)"\"Microsoft Visual Studio 10.0"\VC\vcvarsall.bat x86
   call C:\"Program Files"\"Microsoft Visual Studio 10.0"\VC\vcvarsall.bat x86
   set VCTOOLSET=4.0
   set PLATFORMTOOL=
   goto MSBUILDx86
   )
if %VC_VERSION% == 11 (
   @rem call C:\"Program Files (x86)"\"Microsoft Visual Studio 11.0"\VC\vcvarsall.bat x86
   call C:\"Program Files"\"Microsoft Visual Studio 11.0"\VC\vcvarsall.bat x86
   set VCTOOLSET=4.0
   set PLATFORMTOOL=/p:PlatformToolset=v110
   goto MSBUILDx86
   )
if %VC_VERSION% == 12 (
   @rem call C:\"Program Files (x86)"\"Microsoft Visual Studio 12.0"\VC\vcvarsall.bat x86
   call C:\"Program Files"\"Microsoft Visual Studio 12.0"\VC\vcvarsall.bat x86
   set VCTOOLSET=12.0
   set PLATFORMTOOL=/p:PlatformToolset=v120
   goto MSBUILDx86
   )

@rem ------------------------------------------------------------
@rem Build (VC2010- x86)
@rem ------------------------------------------------------------
:MSBUILDx86
echo Visual Studio Dir: %VSINSTALLDIR%
echo LIB: %LIB%
set OPT=/M:4 /toolsversion:%VCTOOLSET% %PLATFORMTOOL% /p:platform=Win32
set SLN=portaudio.sln
set LOG=/fileLogger /flp:logfile=debug.log /v:diag 

cd %BUILD_DIR%

msbuild /t:build /p:configuration=release %OPT% %SLN%

goto LIB_COPY

@rem ============================================================
@rem start to cmake 64bit 
@rem ============================================================
:cmake_x86_64
cd %BUILD_DIR%
set VC_NAME="Visual Studio %VC_VERSION% Win64"
cmake .. -G %VC_NAME%
goto x86_64

@rem ============================================================
@rem  Compiling 64bit binaries
@rem ============================================================
:x86_64
echo Compiling 64bit binaries
@rem Setting up Visual C++ environment
if /i %VC_VERSION% == 10 (
   call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64
   set VCTOOLSET=4.0
   set PLATFORMTOOL=
   goto MSBUILDx64
   )
if /i %VC_VERSION% == 11 (
   call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" amd64
   set VCTOOLSET=4.0
   set PLATFORMTOOL=/p:PlatformToolset=v110
   goto MSBUILDx64
   )
if /i %VC_VERSION% == 12 (
   call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" amd64
   set VCTOOLSET=12.0
   set PLATFORMTOOL=/p:PlatformToolset=v120
   goto MSBUILDx64
   )
if /i %VC_VERSION% == 14 (
   call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
   set VCTOOLSET=14.0
   set PLATFORMTOOL=/p:PlatformToolset=v140
   goto MSBUILDx64
   )

@rem ------------------------------------------------------------
@rem Build (VC2010- x64)
@rem ------------------------------------------------------------
:MSBUILDx64
echo Visual Studio Dir: %VSINSTALLDIR%
echo LIB: %LIB%
set OPT=/M:4 /toolsversion:%VCTOOLSET% %PLATFORMTOOL% /p:platform=x64
set LOG=/fileLogger /flp:logfile=debug.log /v:diag 
set SLN=portaudio.sln

msbuild /t:build /p:configuration=release %OPT% %SLN%

goto LIB_COPY

:LIB_COPY
cd ..\
mkdir lib
copy work\Release\*.lib lib
copy work\Release\*.dll lib
goto END


:END
set PATH=%PATH_ORG%
