#!/bin/bash
# 4_keep_latest.sh – hoia ainult 3 viimast koopiat
cd ~/praks2/backup
ls -1t src_*.tar.gz | tail -n +4 | xargs -r rm -f
