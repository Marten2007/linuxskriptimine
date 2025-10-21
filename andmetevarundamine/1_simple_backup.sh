#!/bin/bash
# 1_simple_backup.sh – lihtne varukoopia src kaustast backup kausta
tar -czf ~/praks2/backup/src_$(date +%F_%H-%M-%S).tar.gz -C ~/praks2 src
