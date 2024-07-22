@ echo off
REM This script collects the built .exe and .dll files required for running RRDtool.
REM It is supposed to be run after an MSVC build using nmake and libraries from vcpkg.
REM Wolfgang Stöggl <c72578@yahoo.de>, 2017-2022.

REM Run the batch file with command line parameter x64 or x86
if "%1"=="" (
  echo Command line parameter required: x64 or x86
  echo e.g.: %~nx0 x64
  exit /b
)
echo configuration: %1

REM The script is located in the subdirectory win32
echo %~dp0
pushd %~dp0
SET base_dir=..

REM Read current version of RRDtool
SET /p version=<%base_dir%\VERSION
echo RRDtool version: %version%

SET release_dir=%base_dir%\win32\nmake_release_%1_vcpkg\rrdtool-%version%-%1_vcpkg\
echo release_dir: %release_dir%

if exist %base_dir%\win32\nmake_release_%1_vcpkg rmdir %base_dir%\win32\nmake_release_%1_vcpkg /s /q
mkdir -p %release_dir%\files

REM use xcopy instead of copy. xcopy creates directories if necessary and outputs the copied file
REM /Y Suppresses prompting to confirm that you want to overwrite an existing destination file.
REM /D xcopy copies all Source files that are newer than existing Destination files

dir %base_dir%\win32\

xcopy /Y /D /E %base_dir%\win32\* %release_dir%\files

REM The following part needs to be checked and maintained after an update to a new vcpkg version
REM Names of dlls can change over time, which has happened in the past
REM e.g. glib-2.dll -> glib-2.0-0.dll, expat.dll -> libexpat.dll
xcopy /Y /D /E %base_dir%\vcpkg\installed\%1-windows\* %release_dir%

popd
