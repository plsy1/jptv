# jptv

下面是一些用于处理从jptv下载文件的脚本，配合RSS可以实现自动下载入库。

### extract_jp_subtitles.sh

从ts文件提取arib字幕，example.ts同目录下输出example.jp.srt

`./extract_jp_subtitles.sh -d <source_dir> [-o <offset>]`

### jptv_rename

重命名并生成硬链接

`./jptv_rename.sh -s <source_directory> -d <destination_directory> [-t <file_type>]`

### qbittorrent_hook.sh

qbittorrent下载完成回调，硬链接到指定目录

