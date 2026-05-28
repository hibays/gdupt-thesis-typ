# USAGE: bash pdf_pic_synth.sh [-y] [-r dpi] <pdf_path> <page1> <page2> <output.webp> [quality]
#   -y      自动覆盖输出文件（传递给 pic_synthesize.sh）
#   -r dpi  PDF 提取分辨率（默认 150，降低可大幅减小文件体积）
#
# 从 PDF 中提取两页，调用 pic_synthesize.sh 将它们左右拼合为一张图片。
# [quality] 为 WebP 质量参数（1-100），默认为 85。
#
# Example:
#   bash pdf_pic_synth.sh -y -r 72 ../thesis.pdf 3 4 abstract.webp 80

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

OVERWRITE=""
DPI=150
while [[ $# -gt 0 ]]; do
  case "$1" in
    -y) OVERWRITE="-y"; shift ;;
    -r) DPI="$2"; shift 2 ;;
    *) break ;;
  esac
done

if [ $# -lt 4 ] || [ $# -gt 5 ]; then
  echo "USAGE: bash pdf_pic_synth.sh [-y] [-r dpi] <pdf_path> <page1> <page2> <output.webp> [quality]" >&2
  exit 1
fi

PDF_PATH="$1"
PAGE1="$2"
PAGE2="$3"
OUTPUT_PATH="$4"
QUALITY="${5:-85}"

if [ ! -f "$PDF_PATH" ]; then
  echo "Error: PDF not found: $PDF_PATH" >&2
  exit 1
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "Extracting page $PAGE1 from $PDF_PATH (${DPI}DPI) ..." >&2
pdftoppm -png -r "$DPI" -f "$PAGE1" -l "$PAGE1" "$PDF_PATH" "$TMPDIR/p"

echo "Extracting page $PAGE2 from $PDF_PATH (${DPI}DPI) ..." >&2
pdftoppm -png -r "$DPI" -f "$PAGE2" -l "$PAGE2" "$PDF_PATH" "$TMPDIR/q"

PAGE1_PAD=$(printf "%02d" "$PAGE1")
PAGE2_PAD=$(printf "%02d" "$PAGE2")

bash "$SCRIPT_DIR/pic_synthesize.sh" $OVERWRITE "$TMPDIR/p-${PAGE1_PAD}.png" "$TMPDIR/q-${PAGE2_PAD}.png" "$OUTPUT_PATH" "$QUALITY"
