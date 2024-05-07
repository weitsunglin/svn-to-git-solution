#!/bin/bash

# SVN 倉庫的 URL
SVN_REPO_URL="http://192.168.1.183/svn/ManganDahen/branches/Release"

# GitHub 倉庫的 URL
GITHUB_REPO_URL="https://github.com/OLD-RD2/TMDC_ManganDahen"

# 克隆 SVN 數據，限制為最新的 20 筆 commit
mkdir svn-to-git
cd svn-to-git
git svn clone $SVN_REPO_URL . -rHEAD~19:HEAD --authors-file=authors.txt

# SVN 克隆完成後，預設在 master 分支
# 我們需要將它重命名為 Release，以匹配 GitHub 上的分支名稱
git branch -m master Release

# 設定遠程倉庫
git remote add origin $GITHUB_REPO_URL

# 推送到 GitHub 的 Release 分支
git push -u origin Release
