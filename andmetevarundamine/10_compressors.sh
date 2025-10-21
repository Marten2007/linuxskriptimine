#!/bin/bash
# 10_compressors.sh – tee kolm arhiivi eri kompressoritega
tar -czf ~/praks2/backup/src_$(date +%F_%H-%M-%S).tar.gz -C ~/praks2 src
tar -cJf ~/praks2/backup/src_$(date +%F_%H-%M-%S).tar.xz -C ~/praks2 src
tar -cf ~/praks2/backup/src_$(date +%F_%H-%M-%S).tar -C ~/praks2 src
