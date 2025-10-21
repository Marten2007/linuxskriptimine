#!/bin/bash
# 5_exclude.sh – välista teatud failid ja kaustad varundusest
tar -czf ~/praks2/backup/src_exclude_$(date +%F_%H-%M-%S).tar.gz \
  --exclude='*.jpg' --exclude='bin' -C ~/praks2 src
