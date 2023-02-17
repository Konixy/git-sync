@echo off

REM Check if sh is installed
where sh >nul 2>&1
if %errorlevel% == 1 (
    echo sh is not installed.
    echo here is a documentation to install bash and sh: https://korben.info/installer-shell-bash-linux-windows-10.html
    goto end
)

set "newpath=%USERPROFILE%\bin;%PATH%"

rem Update the user's environment variable
setx PATH "%newpath%"

rem Update the current command prompt's environment variable
set PATH="%newpath%"

echo ~/bin has been added to the PATH environment variable.

REM Set the URL and destination directory
set git_sync_url=https://raw.githubusercontent.com/Konixy/git-sync/master/git-sync.sh
set git_sync_exe_url=https://github.com/Konixy/git-sync/releases/latest/download/git-sync.exe
set git_remove_branch_url=https://raw.githubusercontent.com/Konixy/git-sync/master/git-remove-branch.sh
set git_remove_branch_exe_url=https://github.com/Konixy/git-sync/releases/latest/download/git-remove-branch.exe
set dest_dir="%USERPROFILE%\bin"

REM Create the destination directory if it doesn't exist
if not exist %dest_dir% (
    mkdir %dest_dir%
)

REM Download the files
"C:\Program Files\Git\mingw64\bin\curl" -# -L %git_sync_url% %git_sync_exe_url% %git_remove_branch_url% %git_remove_branch_exe_url% -o %dest_dir%\git-sync.sh -o %dest_dir%\git-sync.exe -o %dest_dir%\git-remove-branch.sh -o %dest_dir%\git-remove-branch.exe

echo.
echo Git-Sync successfully installed.
echo.


:end

pause