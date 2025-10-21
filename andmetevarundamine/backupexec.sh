#!/bin/bash
# --- Seaded ---
SRC=~/praks2/src
DEST=~/praks2/backup
LOG=~/praks2/logs/backup.log
DATE=$(date +%F_%H-%M-%S)
ARCHIVE="$DEST/src_${DATE}.tar.gz"
IGNORE_FILE="$SRC/.backupignore"

mkdir -p "$DEST" "$(dirname "$LOG")"

echo "==============================================" >> "$LOG"
echo "[ $(date '+%F %T') ] BACKUP START" >> "$LOG"

# --- 1. Kontrolli, kas allikas on olemas ---
if [ ! -d "$SRC" ]; then
  echo "[ $(date '+%F %T') ] ERROR: Lähtekausta ei leitud: $SRC" | tee -a "$LOG"
  exit 1
fi

# --- 2. Kontrolli vaba ruumi ---
needspace=$(du -sb "$SRC" | awk '{print $1}')
freespace=$(df -B1 "$DEST" | awk 'NR==2{print $4}')

if [ "$freespace" -lt "$needspace" ]; then
  echo "[ $(date '+%F %T') ] ERROR: Pole piisavalt vaba ruumi!" | tee -a "$LOG"
  exit 1
fi
echo "[ $(date '+%F %T') ] Vaba ruumi piisavalt" >> "$LOG"

# --- 3. Tee varukoopia (välistustega, kui fail on olemas) ---
if [ -f "$IGNORE_FILE" ]; then
  echo "[ $(date '+%F %T') ] Kasutan välistusi failist .backupignore" >> "$LOG"
  tar -czf "$ARCHIVE" --exclude-from="$IGNORE_FILE" -C "$(dirname "$SRC")" "$(basename "$SRC")"
else
  tar -czf "$ARCHIVE" -C "$(dirname "$SRC")" "$(basename "$SRC")"
fi

# --- 4. Kontrolli, et arhiiv tekkis ---
if [ ! -f "$ARCHIVE" ]; then
  echo "[ $(date '+%F %T') ] ERROR: Arhiivi ei loodud!" | tee -a "$LOG"
  exit 1
fi
echo "[ $(date '+%F %T') ] Arhiiv loodud: $ARCHIVE" >> "$LOG"

# --- 5. Kontrolli arhiivi sisu ---
if tar -tzf "$ARCHIVE" > /dev/null 2>&1; then
  echo "[ $(date '+%F %T') ] Arhiivi kontroll OK" >> "$LOG"
else
  echo "[ $(date '+%F %T') ] ERROR: Arhiivi kontroll ebaõnnestus!" | tee -a "$LOG"
  exit 1
fi

# --- 6. Näita suurust ---
size=$(du -h "$ARCHIVE" | awk '{print $1}')
echo "[ $(date '+%F %T') ] Arhiivi suurus: $size" >> "$LOG"

# --- 7. Loo SHA256 kontrollsumma ja kontrolli ---
sha256sum "$ARCHIVE" > "$ARCHIVE.sha256"
if sha256sum -c "$ARCHIVE.sha256" > /dev/null 2>&1; then
  echo "[ $(date '+%F %T') ] Kontrollsumma OK" >> "$LOG"
else
  echo "[ $(date '+%F %T') ] ERROR: Kontrollsumma ebaõnnestus!" | tee -a "$LOG"
  exit 1
fi

# --- 8. Hoia alles ainult 3 viimast koopiat ---
cd "$DEST" || exit 1
ls -1t src_*.tar.gz | tail -n +4 | xargs -r rm -f
echo "[ $(date '+%F %T') ] Vanad koopiad eemaldatud (alles jäeti 3 viimast)" >> "$LOG"

# --- 9. “Kuiv jooks” (valikuline, kui käivitatakse argumendiga dry-run) ---
if [ "$1" == "dry-run" ]; then
  echo "[ $(date '+%F %T') ] Kuiv jooks: failid, mida varundataks:" >> "$LOG"
  tar -cf - -C "$(dirname "$SRC")" "$(basename "$SRC")" | tar -tvf - >> "$LOG"
  echo "[ $(date '+%F %T') ] Kuiv jooks lõpetatud." >> "$LOG"
fi

# --- 10. Logi lõpp ---
echo "[ $(date '+%F %T') ] BACKUP END" >> "$LOG"
echo "==============================================" >> "$LOG"

# --- 11. Lõppteade ---
echo "Varundus lõpetatud edukalt! Logi: $LOG"
