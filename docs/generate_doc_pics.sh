# USAGE: bash generate_doc_pics.sh [thesis.pdf path]
#
# 从 thesis.pdf 中提取指定页对，生成 docs 目录下的封面/摘要/章节预览图。
# 默认使用 ../thesis.pdf，也可通过第一个参数指定。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PDF_PATH="${1:-$SCRIPT_DIR/../thesis.pdf}"

bash "$SCRIPT_DIR/pdf_pic_synth.sh" -y -r 155 "$PDF_PATH" 1 2 "$SCRIPT_DIR/cover_and_pro.webp" 81
bash "$SCRIPT_DIR/pdf_pic_synth.sh" -y -r 118 "$PDF_PATH" 3 4 "$SCRIPT_DIR/abstract.webp" 78
bash "$SCRIPT_DIR/pdf_pic_synth.sh" -y -r 120 "$PDF_PATH" 9 10 "$SCRIPT_DIR/1c_and_2c.webp" 81
