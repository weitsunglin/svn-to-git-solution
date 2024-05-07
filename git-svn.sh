#!/bin/bash

# 设置游戏名称
gameName="ManganDahen"

# SVN 仓库的 URL
SVN_REPO_URL="http://192.168.1.183/svn/${gameName}/branches/Release"

# GitHub 仓库的 URL
GITHUB_REPO_URL="https://github.com/OLD-RD2/TMDC_${gameName}"

# 克隆 SVN 数据，限制为最新的 20 篇 commit
mkdir "${gameName}"
cd "${gameName}"
git svn clone "${SVN_REPO_URL}" . -rHEAD~19:HEAD --authors-file=authors.txt

# SVN 克隆完成后，默认在 master 分支
# 我们需要将它重命名为 Release，以匹配 GitHub 上的分支名称
git branch -m master Release

# 设置远程仓库
git remote add origin "${GITHUB_REPO_URL}"

# 推送到 GitHub 的 Release 分支
git push -u origin Release
