#!/bin/bash
# Upload product_v1_bootstrap + hard_negatives to github.com/Mikhail-Sklyarenko/train-pc
# Requires ~6 GB free disk on Mac (git stores compressed copies of all images).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/../farm-panel-prototype/vendor/csgobot/yolov8/datasets"
DEST="$ROOT/vendor/csgobot/yolov8/datasets"

need_gb=6
free_kb=$(df -k "$ROOT" | awk 'NR==2 {print $4}')
free_gb=$((free_kb / 1024 / 1024))
if (( free_gb < need_gb )); then
  echo "ERROR: need ~${need_gb} GB free, have ~${free_gb} GB"
  echo "Free disk space on Mac (Trash, old builds, .venv) then re-run."
  exit 1
fi

mkdir -p "$DEST/sources"

if [[ ! -d "$DEST/product_v1_bootstrap/train/images" ]]; then
  echo "Link-copy product_v1_bootstrap (no duplicate disk)..."
  rsync -a --link-dest="$SRC/product_v1_bootstrap" \
    "$SRC/product_v1_bootstrap/" "$DEST/product_v1_bootstrap/"
fi

if [[ ! -d "$DEST/sources/hard_negatives/train/images" ]]; then
  echo "Link-copy hard_negatives..."
  rsync -a --link-dest="$SRC/sources/hard_negatives" \
    "$SRC/sources/hard_negatives/" "$DEST/sources/hard_negatives/"
fi

cd "$ROOT"
if [[ ! -d .git ]]; then
  git init -b main
  git remote add origin https://github.com/Mikhail-Sklyarenko/train-pc.git
fi

git add README.md .gitignore vendor/
git status --short | head
echo "Committing (may take several minutes)..."
git commit -m "$(cat <<'EOF'
Add CS2 YOLO datasets for Train PC.

product_v1_bootstrap (5473 images) + sources/hard_negatives (1670 images).
Sorted on Mac; poison datasets excluded.
EOF
)" || true

echo "Pushing to GitHub (~5 GB, may take a long time)..."
git push -u origin main

echo "OK: https://github.com/Mikhail-Sklyarenko/train-pc"
