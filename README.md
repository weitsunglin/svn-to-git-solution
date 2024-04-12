## Git clone svn repo

![git clone svn](https://github.com/weitsunglin/svn-to-git-solution/blob/main/git%20clone%20svn%20repo.jpg)


## Git local repo設定 remote 目標

![remote setting](https://github.com/weitsunglin/svn-to-git-solution/blob/main/remote%20setting.jpg)

## 尋找大型檔案

如果出現在.git中的大型檔案，代表歷史紀錄中曾有過大型檔案 <br>
如果出現在專案中其餘路徑，代表現在還存在著大型檔案 <br>
可自行替換 folder_path  
```bat
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
```

## Git LFS 使用指南

當開發項目中需要處理大型檔案時，Git LFS（Large File Storage）提供了一種高效的管理方式。<br>
這裡介紹三個主要的 Git LFS 相關操作，幫助你更好地管理項目中的大型檔案。

1. 追踪新的大型檔案
在項目開始階段或當你需要開始追踪新類型的大型檔案時，可以使用 git lfs track 命令。<br>
這個命令將指定的檔案或檔案類型加入到 Git LFS 的追踪列表中。

例如，要追踪 example.txt 文件，可以使用以下命令：

```bat
git lfs track ‘example.txt’
```

這樣，每當你提交這些文件時，Git LFS 會處理這些大型檔案，而不是將它們直接儲存在 Git 倉庫中。

2. 導入現有的大型檔案到 Git LFS
如果你的倉庫歷史中已經包含了大型檔案，而你想要開始使用 Git LFS 來更有效地管理這些文件，而不是徹底移除它們，可以使用 git lfs migrate import 命令。

這個命令允許你指定要導入到 Git LFS 的文件或文件類型，並重新寫入倉庫歷史，以便這些文件由 Git LFS 管理。

例如，要導入example.txt,example2.txt到 Git LFS，可以使用以下命令：

```bat
git lfs migrate import --include="example.txt,example2.txt" --everything
```

3. 從倉庫歷史中移除大型檔案
如果你想要徹底從倉庫歷史中移除某些文件或數據，使其好像從未被提交過一樣，git filter-repo 是一個非常有用的工具。

這個命令提供了一種方式來清理倉庫歷史，包括徹底移除大型檔案或敏感數據。

例如，要從歷史中移除 example.txt 檔案，可以使用以下命令：

```bat
git filter-repo --path example.txt --invert-paths --force
```

以上介紹的三個操作是使用 Git LFS 管理大型檔案的基礎，幫助你有效地處理和維護項目中的大型檔案。


## 批次上傳檔案

如果單次Push超過2GB，可使用批次Push功能。<br>
cd TMDC_Inanna 可自行替換路徑。
```bat
@echo off
cd TMDC_Inanna 

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

```
## 不斷地從svn撈進度push到git repo

```bat
@echo off
set PROJECT_PATH=F:\_project\tmd_1.0\tmd_on_git

for /d /r "%PROJECT_PATH%" %%d in (*) do (
    if exist "%%d\.git" (
        echo Found .git in: %%d
        cd /d %%d
        git --version
        git svn fetch
        git svn rebase
        for /f "tokens=*" %%b in ('git branch --show-current') do set branch=%%b
        git push origin %branch%
    )
)
```

## 注意事項 (要看)
1. git clone svn 的 repo 預設的分支會是master，可將其改成main再push。
2. 再github上建立repo時，先別建README.md，目的是讓歷史紀錄保持乾淨，這樣再跟svn repo合併時，才不會產生歷史紀錄不一致的問題。
3. 遇到單次commit過大，可調整緩衝區大小 git config --global http.postBuffer 524288000 (提高git commit 緩衝區大小: 500mb)
