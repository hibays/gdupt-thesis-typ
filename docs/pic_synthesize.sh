# USAGE: bash pic_synthesize.sh [-y] <pic1 path> <pic2 path> <output pic path> [quality]
#   -y  自动覆盖输出文件（不询问）


# 先为左侧图片右侧补 2px 灰色，右侧图片左侧补 2px 灰色（合并后中间正好形成 4px 灰色分隔条）。
# 用 hstack 将两张处理后的图片左右拼接。
# 最后用 pad 在合成图四周各添加 3px 灰色边框（总宽高分别增加 6px）。
# ffmpeg -color; silver - lightgrey; silver 稍深色一点
# 输出编码为 WebP，质量参数通过 [quality] 指定，默认为 85。

set -euo pipefail

OVERWRITE=""
if [ "${1:-}" = "-y" ]; then
  OVERWRITE="-y"
  shift
fi

if [ $# -lt 3 ] || [ $# -gt 4 ]; then
  echo "USAGE: bash pic_synthesize.sh [-y] <pic1 path> <pic2 path> <output pic path> [quality]" >&2
  exit 1
fi

PIC1="$1"
PIC2="$2"
OUTPUT_PATH="$3"
QUALITY="${4:-85}"

CODEC_ARGS=()
if [[ "$OUTPUT_PATH" == *.webp ]] || [[ "$OUTPUT_PATH" == *.WEBP ]]; then
  CODEC_ARGS+=(-c:v libwebp)
fi

ffmpeg $OVERWRITE -hide_banner -i "$PIC1" -i "$PIC2" \
  -filter_complex "
    [0:v]pad=iw+2:ih:0:0:color=lightgrey[left];
    [1:v]pad=iw+2:ih:2:0:color=lightgrey[right];
    [left][right]hstack[merged];
    [merged]pad=iw+6:ih+6:3:3:color=silver
  " \
  "${CODEC_ARGS[@]}" -q:v "$QUALITY" "$OUTPUT_PATH"
