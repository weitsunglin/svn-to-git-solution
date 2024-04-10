@echo off
setlocal enabledelayedexpansion

set "folder_path=F:\_project\tmd_1.0\tmd_on_git\TMDC_Boost"
set "min_size=104857600"

echo find 100mb file:
for /r "%folder_path%" %%F in (*.*) do (
    set size=%%~zF
    if !size! geq %min_size% echo %%F !size! bytes
)

pause


