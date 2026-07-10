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

# Sample-photo gallery: 3 square thumbs per section (WebP + JPG). Edit the ids to swap.
gal_keys=(calientes-1 calientes-2 calientes-3 frias-1 frias-2 frias-3 \
          sandwiches-1 sandwiches-2 sandwiches-3 postres-1 postres-2 postres-3)
gal_ids=(3 46 125 90 81 74 161 169 66 20 117 35)
for i in "${!gal_keys[@]}"; do
  k=${gal_keys[$i]}; id=${gal_ids[$i]}
  magick "$SRC/0922-$id.jpg" -auto-orient -resize 300x300^ -gravity center -extent 300x300 \
    -unsharp 0x0.8 -quality 82 "$OUT/gal-$k.jpg"
  magick "$OUT/gal-$k.jpg" -quality 80 -define webp:method=6 "$OUT/gal-$k.webp"
done
echo "gallery: 12 square thumbs (gal-*.jpg/.webp)"

# Brand logo (transparent PNG source) -> web WebP (alpha) + quantized PNG fallback,
# plus a 180x180 apple-touch-icon on a cream background.
if [ -f "$SRC/logo.png" ]; then
  magick "$SRC/logo.png" -trim +repage -resize 520x -strip -define webp:method=6 -quality 88 "$OUT/logo.webp"
  magick "$SRC/logo.png" -trim +repage -resize 520x -strip -colors 64 -define png:compression-level=9 "$OUT/logo.png"
  magick "$SRC/logo.png" -trim +repage -resize 148x148 -background "#f3efe9" -gravity center -extent 180x180 -strip "$OUT/apple-touch-icon.png"
  echo "logo.webp / logo.png / apple-touch-icon.png  (from logo.png)"
fi

echo "Done. Wrote $(ls "$OUT" | wc -l) files to assets/img/"
