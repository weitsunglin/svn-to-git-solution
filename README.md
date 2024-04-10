# svn-to-git-solution
提供從svn挪檔案到git的解決方案

## Git LFS 使用指南

當開發項目中需要處理大型檔案時，Git LFS（Large File Storage）提供了一種高效的管理方式。這裡介紹三個主要的 Git LFS 相關操作，幫助你更好地管理項目中的大型檔案。

1. 追踪新的大型檔案
在項目開始階段或當你需要開始追踪新類型的大型檔案時，可以使用 git lfs track 命令。這個命令將指定的檔案或檔案類型加入到 Git LFS 的追踪列表中。

例如，要追踪 iOS 框架中的 boost.framework 文件，可以使用以下命令：

```bat
git lfs track ‘IOS/framework/boost.framework/Versions/A/boost’
```

這樣，每當你提交這些文件時，Git LFS 會處理這些大型檔案，而不是將它們直接儲存在 Git 倉庫中。


Git LFS 使用指南
當開發項目中需要處理大型檔案時，Git LFS（Large File Storage）提供了一種高效的管理方式。這裡介紹三個主要的 Git LFS 相關操作，幫助你更好地管理項目中的大型檔案。

1. 追踪新的大型檔案
在項目開始階段或當你需要開始追踪新類型的大型檔案時，可以使用 git lfs track 命令。這個命令將指定的檔案或檔案類型加入到 Git LFS 的追踪列表中。

例如，要追踪 iOS 框架中的 boost.framework 文件，可以使用以下命令：

```bat
git lfs track ‘example.txt’
```

這樣，每當你提交這些文件時，Git LFS 會處理這些大型檔案，而不是將它們直接儲存在 Git 倉庫中。

2. 導入現有的大型檔案到 Git LFS
如果你的倉庫歷史中已經包含了大型檔案，而你想要開始使用 Git LFS 來更有效地管理這些文件，而不是徹底移除它們，可以使用 git lfs migrate import 命令。

這個命令允許你指定要導入到 Git LFS 的文件或文件類型，並重新寫入倉庫歷史，以便這些文件由 Git LFS 管理。

例如，要導入遊戲錄影和測試報告檔案到 Git LFS，可以使用以下命令：

```bat
git lfs migrate import --include="example.txt,example2.txt" --everything
```

3. 從倉庫歷史中移除大型檔案
如果你想要徹底從倉庫歷史中移除某些文件或數據，使其好像從未被提交過一樣，git filter-repo 是一個非常有用的工具。

這個命令提供了一種方式來清理倉庫歷史，包括徹底移除大型檔案或敏感數據。

例如，要從歷史中移除 LiveServer 的某個特定檔案，可以使用以下命令：

```bat
git filter-repo --path example.txt --invert-paths --force
```

以上介紹的三個操作是使用 Git LFS 管理大型檔案的基礎，幫助你有效地處理和維護項目中的大型檔案。

