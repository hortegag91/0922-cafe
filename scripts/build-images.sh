#!/usr/bin/env bash
#
# Regenerate the web-optimized menu images in assets/img/ from the full-res
# originals in "Fotos Listas/". Requires ImageMagick 7 (`magick`) with WebP support.
#
#   bash scripts/build-images.sh
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/Fotos Listas"
OUT="$ROOT/assets/img"
mkdir -p "$OUT"

if [ ! -d "$SRC" ]; then
  echo "Source folder not found: $SRC" >&2
  echo "The full-res originals are git-ignored; restore them to regenerate." >&2
  exit 1
fi

# Selected photo id -> role. Change these ids to swap the photography.
HERO_calientes=8      CARD_calientes=3
HERO_frias=10         CARD_frias=9
HERO_sandwiches=143   CARD_sandwiches=95
HERO_postres=52       CARD_postres=117

mkhero() { # $1 name  $2 id   -> wide banner 960x360
  magick "$SRC/0922-$2.jpg" -auto-orient -resize 960x360^ -gravity center -extent 960x360 \
    -unsharp 0x0.8 -quality 82 "$OUT/hero-$1.jpg"
  magick "$OUT/hero-$1.jpg" -quality 80 -define webp:method=6 "$OUT/hero-$1.webp"
  echo "hero-$1  (from 0922-$2.jpg)"
}
mkcard() { # $1 name  $2 id   -> thumb 320x278
  magick "$SRC/0922-$2.jpg" -auto-orient -resize 320x278^ -gravity center -extent 320x278 \
    -unsharp 0x0.8 -quality 82 "$OUT/card-$1.jpg"
  magick "$OUT/card-$1.jpg" -quality 80 -define webp:method=6 "$OUT/card-$1.webp"
  echo "card-$1  (from 0922-$2.jpg)"
}

for name in calientes frias sandwiches postres; do
  eval "mkhero $name \$HERO_$name"
  eval "mkcard $name \$CARD_$name"
done

echo "Done. Wrote $(ls "$OUT" | wc -l) files to assets/img/"
