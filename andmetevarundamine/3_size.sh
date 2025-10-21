#!/bin/bash
# 3_size.sh – näita varukoopia suurust
du -h ~/praks2/backup/src_*.tar.gz | awk '{print $1}'
