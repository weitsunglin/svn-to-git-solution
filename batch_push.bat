@echo off
cd TMDC_Inanna
echo cd cd cd cd cd

:: 生成commit-list.txt，每10個提交紀錄一次
git rev-list --topo-order --reverse HEAD > temp_commit_list.txt
setlocal EnableDelayedExpansion
set /a "line=0"
set /a "count=0"

for /F "tokens=*" %%A in (temp_commit_list.txt) do (
    set /a "line+=1"
    set /a "mod=line %% 10"
    if !mod! equ 0 (
        echo %%A >> commit-list.txt
    )
)
del temp_commit_list.txt
echo rev-list rev-list

:: 遍歷commit-list.txt中的每個提交
for /F "tokens=*" %%B in (commit-list.txt) do (
    git reset --hard %%B
    git push origin ReleaseWindows
    echo Current SHA: %%B
)

pause
