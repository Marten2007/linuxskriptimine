#!/bin/bash
# ----------------------------------------
# PHP + Apache paigaldusskript (Debian 10–12)
# Autor: Marten
# Kuupäev: $(date +%Y-%m-%d)
# ----------------------------------------

echo "=== PHP paigaldamise protsess algab... ==="

# Kontrollime, kas kasutaja on root
if [ "$EUID" -ne 0 ]; then
  echo "Palun käivita see skript root kasutajana (kasuta: sudo ./php_paigaldus.sh)"
  exit 1
fi

# Uuendame paketilist
echo "Uuendan paketilist..."
apt update -y

# Kontrollime, kas Apache on paigaldatud
if ! command -v apache2 > /dev/null 2>&1; then
  echo "Apache2 pole paigaldatud – paigaldan selle..."
  apt install -y apache2
else
  echo "Apache2 juba olemas."
fi

# Paigaldame PHP ja vajalikud moodulid
echo "Paigaldan PHP ja vajalikud moodulid..."
apt install -y php libapache2-mod-php php-mysql

# Kontrollime, kas PHP paigaldus õnnestus
if ! command -v php > /dev/null 2>&1; then
  echo "VIGA: PHP paigaldamine ebaõnnestus!"
  exit 1
fi

# Aktiveerime PHP toe Apache-s
echo "Aktiveerin PHP toe Apache-s..."
a2enmod php* >/dev/null 2>&1

# Loome testfaili
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Taaskäivitame Apache teenuse
echo "Taaskäivitan Apache teenuse..."
systemctl restart apache2

# Kontrollime, kas Apache töötab
if systemctl is-active --quiet apache2; then
  echo "Apache töötab korrektselt."
else
  echo "VIGA: Apache ei käivitu! Kontrolli käsuga: systemctl status apache2"
fi

# Kuvame PHP versiooni
php -v

echo "-----------------------------------------------------"
echo "PHP ja Apache on edukalt paigaldatud!"
echo "Kontrolli PHP toimimist brauseris aadressil:"
echo "  http://$(hostname -I | awk '{print $1}')/info.php"
echo "-----------------------------------------------------"
