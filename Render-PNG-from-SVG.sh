#!/bin/sh
set -eu

# Usage:
#   ./Render-PNG-from-SVG.sh [width]
#
# Examples:
#   ./Render-PNG-from-SVG.sh      # width 2200 (current default)
#   ./Render-PNG-from-SVG.sh 4400 # twice the resolution/sharper zoom

width="${1:-2200}"

case "$width" in
  ''|*[!0-9]*) echo "Width must be a positive integer." >&2; exit 2 ;;
esac

if [ "$width" -eq 0 ]; then
  echo "Width must be a positive integer." >&2
  exit 2
fi

script_directory=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
svg="$script_directory/Hekatean-Orphic-Mystery.svg"
png="$script_directory/Hekatean-Orphic-Mystery.png"
temporary_png="$script_directory/Hekatean-Orphic-Mystery.rendering.$$.png"

trap 'rm -f "$temporary_png"' EXIT HUP INT TERM

if ! command -v magick >/dev/null 2>&1; then
  echo "ImageMagick is required: the 'magick' command was not found." >&2
  exit 1
fi

if [ ! -f "$svg" ]; then
  echo "SVG not found: $svg" >&2
  exit 1
fi

echo "Rendering PNG at ${width}px wide with maximum lossless compression..."
magick -background '#101820' \
  "$svg" \
  -resize "${width}x" \
  -define png:compression-filter=5 \
  -define png:compression-level=9 \
  -define png:compression-strategy=1 \
  "$temporary_png"

mv "$temporary_png" "$png"
trap - EXIT HUP INT TERM

echo "Created: $png"
