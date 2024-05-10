#!/bin/bash
git config --global http.postBuffer 7048576000
# 进入项目目录
cd git_repo_release/FishHunter

# 生成commit-list.txt，每10个提交记录一次
git rev-list --topo-order --reverse HEAD > temp_commit_list.txt

line=0
count=0

# 读取临时提交列表，并每10个提交保存一次到 commit-list.txt
while IFS= read -r commit; do
    ((line++))
    mod=$((line % 1))
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
    git push origin Release
    echo "Current SHA: $commit"
done < commit-list.txt

# 暂停等待用户输入（模拟 Windows 批处理中的 pause 命令）
read -p "Press enter to continue..."