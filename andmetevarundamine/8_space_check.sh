#!/bin/bash
# 8_space_check.sh – kontrolli enne varundust, kas piisavalt ruumi on
SRC=~/praks2/src
DEST=~/praks2/backup

needspace=$(du -sb "$SRC" | awk '{print $1}')
freespace=$(df -B1 "$DEST" | awk 'NR==2{print $4}')

echo "Vajalik ruum: $needspace baiti"
echo "Vaba ruum: $freespace baiti"

if [ "$freespace" -lt "$needspace" ]; then
  echo "❌ Pole piisavalt vaba ruumi!"
  exit 1
else
  echo "✅ Ruum piisav, alustan varundust..."
  tar -czf "$DEST/src_space_$(date +%F_%H-%M-%S).tar.gz" -C ~/praks2 src
fi
