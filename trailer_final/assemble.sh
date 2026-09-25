#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE="$ROOT/trailer_final"
C="$BASE/clips"

if [[ -n "${FFMPEG:-}" ]]; then
  FFMPEG_BIN="$FFMPEG"
elif command -v ffmpeg >/dev/null 2>&1; then
  FFMPEG_BIN="$(command -v ffmpeg)"
elif python -c 'import imageio_ffmpeg' >/dev/null 2>&1; then
  FFMPEG_BIN="$(python -c 'import imageio_ffmpeg; print(imageio_ffmpeg.get_ffmpeg_exe())')"
else
  echo "FFmpeg is required." >&2
  exit 1
fi

# 9.6-second show intro using the first supplied theme-song version.
"$FFMPEG_BIN" -hide_banner -loglevel error -y \
  -i "$C/07_panel_title_insert.mp4" \
  -i "$C/01_panel_title_slider.mp4" \
  -i "$C/06_panel_to_microphone.mp4" \
  -i "$C/02_stage_tilt_down.mp4" \
  -i "$C/09_microphone_detail.mp4" \
  -i "$ROOT/res/BACKBENCHERS! (1).mp3" \
  -filter_complex "\
    [0:v]setpts=PTS-STARTPTS[v0];\
    [1:v]setpts=PTS-STARTPTS[v1];\
    [2:v]setpts=PTS-STARTPTS[v2];\
    [3:v]setpts=PTS-STARTPTS[v3];\
    [4:v]setpts=PTS-STARTPTS[v4];\
    [v0][v1][v2][v3][v4]concat=n=5:v=1:a=0,\
      fade=t=in:st=0:d=0.12,fade=t=out:st=9.10:d=0.50,format=yuv420p[v];\
    [5:a]atrim=start=0:end=9.6,asetpts=PTS-STARTPTS,\
      afade=t=in:st=0:d=0.15,afade=t=out:st=8.8:d=0.8,volume=0.94[a]" \
  -map '[v]' -map '[a]' -r 25 -shortest \
  -c:v libx264 -preset slow -crf 16 -profile:v high -level 4.1 \
  -c:a aac -b:a 256k -ar 48000 \
  -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
  -movflags +faststart "$BASE/backbenchers_intro.mp4"

# 36-second trailer cut on a 100-BPM grid, using the second supplied theme song.
inputs=(
  04_full_room_crane_drop.mp4
  10_five_chair_reveal.mp4
  08_emblem_detail.mp4
  06_panel_to_microphone.mp4
  03_five_seat_desk_slider.mp4
  09_microphone_detail.mp4
  05_overhead_diagonal.mp4
  07_panel_title_insert.mp4
  11_audience_master_sweep.mp4
  02_stage_tilt_down.mp4
  01_panel_title_slider.mp4
  08_emblem_detail.mp4
  10_five_chair_reveal.mp4
  06_panel_to_microphone.mp4
  05_overhead_diagonal.mp4
  09_microphone_detail.mp4
  12_finale_crane_rise.mp4
  01_panel_title_slider.mp4
)
args=()
filters=()
labels=()
for i in "${!inputs[@]}"; do
  args+=( -i "$C/${inputs[$i]}" )
  filters+=( "[$i:v]setpts=PTS-STARTPTS[v$i]" )
  labels+=( "[v$i]" )
done
args+=( -i "$ROOT/res/BACKBENCHERS!.mp3" )
audio_index=${#inputs[@]}
filter_prefix=$(IFS=';'; echo "${filters[*]}")
label_chain=$(printf '%s' "${labels[@]}")

"$FFMPEG_BIN" -hide_banner -loglevel error -y \
  "${args[@]}" \
  -filter_complex "\
    $filter_prefix;\
    ${label_chain}concat=n=${#inputs[@]}:v=1:a=0,\
      fade=t=in:st=0:d=0.10,fade=t=out:st=35.35:d=0.65,format=yuv420p[v];\
    [$audio_index:a]atrim=start=0:end=36,asetpts=PTS-STARTPTS,\
      afade=t=in:st=0:d=0.12,afade=t=out:st=35.1:d=0.9,volume=0.94[a]" \
  -map '[v]' -map '[a]' -r 25 -shortest \
  -c:v libx264 -preset slow -crf 16 -profile:v high -level 4.1 \
  -c:a aac -b:a 256k -ar 48000 \
  -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
  -movflags +faststart "$BASE/backbenchers_trailer.mp4"

printf 'Created %s and %s\n' "$BASE/backbenchers_intro.mp4" "$BASE/backbenchers_trailer.mp4"
