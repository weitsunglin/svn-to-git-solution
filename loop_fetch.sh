

#!/bin/bash
PROJECT_PATH="/Users/tmd/Desktop/tmd_git/repo"

find "$PROJECT_PATH" -type d | while read -r directory; do
    if [[ -d "$directory/.git" ]]; then
        echo "Found .git in: $directory"
        cd "$directory" || exit
        git --version
        git svn fetch
        git svn rebase
        branch=$(git branch --show-current)
        git push origin "$branch"
    fi
done
echo "END"
