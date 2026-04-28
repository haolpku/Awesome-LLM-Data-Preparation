#!/usr/bin/env bash
# Converts repo/assets/*.pdf → repo/assets/*.png so that the figures render inline
# in the GitHub README. After running this, the commented-out <img> / ![] lines in
# README.md and README_zh.md can be uncommented.
#
# Requires ONE of:
#   - poppler (brew install poppler)       → provides pdftoppm
#   - ImageMagick + Ghostscript            → `magick` / `convert`
#
# Usage:
#   bash scripts/convert_pdf_to_png.sh

set -euo pipefail

ASSETS_DIR="$(cd "$(dirname "$0")/.." && pwd)/assets"
cd "$ASSETS_DIR"

convert_one () {
  local pdf="$1"
  local base="${pdf%.pdf}"
  if command -v pdftoppm >/dev/null 2>&1; then
    echo "[pdftoppm] $pdf -> ${base}.png"
    pdftoppm -png -r 220 "$pdf" "$base"
    # pdftoppm emits $base-1.png for single-page PDFs; rename if needed
    if [[ -f "${base}-1.png" && ! -f "${base}.png" ]]; then
      mv "${base}-1.png" "${base}.png"
    fi
  elif command -v magick >/dev/null 2>&1; then
    echo "[ImageMagick] $pdf -> ${base}.png"
    magick -density 220 "$pdf" -quality 92 "${base}.png"
  elif command -v convert >/dev/null 2>&1; then
    echo "[convert] $pdf -> ${base}.png"
    convert -density 220 "$pdf" -quality 92 "${base}.png"
  else
    echo "Error: install poppler (pdftoppm) or ImageMagick (magick/convert) first." >&2
    exit 1
  fi
}

for pdf in *.pdf; do
  [[ -e "$pdf" ]] || continue
  convert_one "$pdf"
done

echo "Done. Uncomment the <img> / ![] tags in README.md and README_zh.md."
