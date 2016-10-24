@echo off

set /phouseNumber="Please input house number: "
set /pusername="Please input user name: "
set /ppassword="Please input password: "

echo {"houseNumber": "%houseNumber%", "username": "%username%", "password": "%password%"} > input.json

echo "Script Path is: "
set scriptPath=%~d0%~p0
echo %scriptPath%

echo "Ruby Path:"
set ruby=%scriptPath%Ruby200\bin\ruby.exe
echo %ruby%

echo "Ruby version:"
call %ruby% -v
if ERRORLEVEL 1 goto Failed

echo "Current working directory:"
echo %CD%

echo "Bundle path:"
set bundle=%scriptPath%Ruby200\bin\bundle
echo %bundle%

call %ruby% %bundle%
if ERRORLEVEL 1 goto Failed

REM echo "GEM Path:"
REM set gem=%scriptPath%Ruby200\bin\gem
REM echo %gem%

REM call %ruby% %gem% install
REM if ERRORLEVEL 1 goto Failed

echo "PATH="
set PATH=%PATH%;%CD%\tools
echo %PATH%

echo "cucumber path:"
set cucumber=%scriptPath%Ruby200\lib\ruby\gems\2.0.0\gems\cucumber-2.4.0\bin\cucumber
echo %cucumber%

call %ruby% %cucumber%
if ERRORLEVEL 1 goto Failed

echo "Python Path is: "
set python=%scriptPath%Python27\python.exe
echo %python%

call %python% batch_download_pic.py 'features\bnb.feature'

:Failed
set EXITCODE=1
@pause

:Success
EXIT /B %EXITCODE%