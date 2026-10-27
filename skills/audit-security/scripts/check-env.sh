#!/bin/bash
# Vérifie que les fichiers d'environnement ne risquent pas de fuiter.
echo "== check-env : hygiène des fichiers d'environnement =="
if [ -f .env ]; then
  echo "[INFO] Un fichier .env est présent à la racine."
  if [ -f .gitignore ] && grep -qE "^\.env([[:space:]]|$)" .gitignore; then
    echo "[OK] .env est couvert par .gitignore."
  else
    echo "[ALERTE] Aucun .gitignore ne couvre .env : secrets exposés dès la mise sous git."
  fi
else
  echo "[OK] Pas de fichier .env à la racine."
fi
