#!/bin/bash
# 11_backupignore.sh – kasuta .backupignore failist välistusi
tar -czf ~/praks2/backup/src_ignore_$(date +%F_%H-%M-%S).tar.gz \
  --exclude-from=~/praks2/src/.backupignore -C ~/praks2 src
