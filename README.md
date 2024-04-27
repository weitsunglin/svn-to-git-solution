## SVN 搬移 REPO 到 GIT 扼要
1. 基於svn url 用 git clone 建 repo (如果該repo歷史紀錄太多，可選擇從指定revision clone到git repo)
2. 設定git remote (svn-git remote再第一步驟會幫你建好)
3. 從svn clone repo下來通常預測會是master，要手動將其改成main (Browse references中查看)
4. git push origin main 會遇到一些問題
   1.大檔案
   2.太多檔案
   3.過去單次commit紀錄過大
6. 如svn有新commit (git svn fetch → git svn rebase → git push)
   1.可指定revision

## Git clone svn repo

![git clone svn](https://github.com/weitsunglin/svn-to-git-solution/blob/main/git%20clone%20svn%20repo.jpg)


## Git local repo設定 remote 目標

![remote setting](https://github.com/weitsunglin/svn-to-git-solution/blob/main/remote%20setting.jpg)

## .git config 檔案中 設定 git-svn 路徑
提供三種範例
```
[svn-remote "svn"]
	url = http://192.168.1.183/svn/SouthPark
	fetch = trunk:refs/remotes/origin/main
```
```
[svn-remote "svn"]
	url = http://192.168.1.183/svn/Casino/trunk
	fetch = :refs/remotes/git-svn
```
```
[svn-remote "svn"]
	url = http://192.168.1.183/svn/ManganDahen
	fetch = branches/Release:refs/remotes/origin/main
```
 
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

``` sh 
#!/bin/bash

# 进入项目目录
cd /path/to/TMDC_Inanna

# 生成commit-list.txt，每10个提交记录一次
git rev-list --topo-order --reverse HEAD > temp_commit_list.txt

line=0
count=0

# 读取临时提交列表，并每10个提交保存一次到 commit-list.txt
while IFS= read -r commit; do
    ((line++))
    mod=$((line % 10))
    if [ "$mod" -eq 0 ]; then
        echo "$commit" >> commit-list.txt
    fi
done < temp_commit_list.txt

# 删除临时文件
rm temp_commit_list.txt
echo "rev-list completed"

# 遍历commit-list.txt中的每个提交
while IFS= read -r commit; do
    git reset --hard "$commit"
    git push origin ReleaseWindows
    echo "Current SHA: $commit"
done < commit-list.txt

# 暂停等待用户输入（模拟 Windows 批处理中的 pause 命令）
read -p "Press enter to continue..."
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
        :: git svn fetch -r2074:HEAD 從指定svn revision fetch 修訂歷史 到 git 
        git svn fetch
        git svn rebase
        for /f "tokens=*" %%b in ('git branch --show-current') do set branch=%%b
        git push origin %branch%
    )
)
```
```sh
#!/bin/bash

# 設定項目路徑
PROJECT_PATH="/path/to/your/project"

# 變例目錄下的所有文件夹
find "$PROJECT_PATH" -type d | while read -r dir; do
    if [[ -d "$dir/.git" ]]; then
        echo "Found .git in: $dir"
        cd "$dir" || exit
        git --version
        git svn fetch
        git svn rebase
        branch=$(git branch --show-current)
        git push origin "$branch"
    fi
done

echo "END"
```


## 常用指令
1. 從某地方複製資料夾到目的地: xcopy F:\_project\tmd_1.0\tmd_on_git\MisrSlot F:\_project\tmd_1.0\tmd_on_git\lfs-backup\MisrSlot\ /E /I /H /K
2. 砍路徑中的資料夾: rd /s /q "F:\_project\tmd_1.0\tmd_on_git\lfs-backup"
3. 移除最新的commit紀錄: git reset --hard HEAD~1


## 注意事項 (要看)
1. git clone svn 的 repo 預設的分支會是master，可將其改成main再push。
2. 再github上建立repo時，先別建README.md，目的是讓歷史紀錄保持乾淨，這樣再跟svn repo合併時，才不會產生歷史紀錄不一致的問題。
3. 遇到單次commit過大，可調整緩衝區大小 git config --global http.postBuffer 524288000 (提高git commit 緩衝區大小: 500mb)。
4. 可以不用上傳.gitattributes，因為要讓歷史紀錄保持乾淨，亦即跟svn一樣。
5. 遇到 pull遇到 fatal: refusing to merge unrelated histories。使用git pull origin main --allow-unrelated-histories。強制合併兩個不同的歷史紀錄。但不建議這樣做，盡量保持一致。


