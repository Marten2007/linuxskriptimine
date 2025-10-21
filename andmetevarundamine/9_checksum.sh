#!/bin/bash
# 9_checksum.sh – loo ja kontrolli SHA256 kontrollsummat
ARCHIVE=$(ls -1t ~/praks2/backup/src_*.tar.gz | head -n 1)

echo "Arvutan kontrollsumma failile: $ARCHIVE"
sha256sum "$ARCHIVE" > "$ARCHIVE.sha256"

echo "Kontrollin faili terviklikkust:"
sha256sum -c "$ARCHIVE.sha256"
