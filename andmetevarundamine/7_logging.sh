#!/bin/bash
# 7_logging.sh – logi varunduse algus ja lõpp
LOG=~/praks2/logs/backup.log
echo "[ $(date '+%F %T') ] BACKUP START" >> "$LOG"
tar -czf ~/praks2/backup/src_log_$(date +%F_%H-%M-%S).tar.gz -C ~/praks2 src
echo "[ $(date '+%F %T') ] BACKUP END" >> "$LOG"
