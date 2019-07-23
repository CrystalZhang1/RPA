@echo off

if not "%~0"=="%~dp0.\%~nx0" (
    start /min cmd /c,"%~dp0.\%~nx0" %*
    exit
)

cd %1

rem clean up working folder
rmdir /s /q log report
mkdir log report

rem execute it
main_gui.exe
