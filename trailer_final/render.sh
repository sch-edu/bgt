#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE="$ROOT/trailer_final"
FPS=25

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

mkdir -p "$BASE/clips"

# Fixed-scale pans, tilts and diagonal moves: no slow synthetic zooms.
# x/y expressions include only a tiny 1–2 px operator-style drift.
render_move() {
  local src="$1" out="$2" frames="$3" sw="$4" sh="$5" x0="$6" x1="$7" y0="$8" y1="$9"
  local last=$((frames - 1))
  local ease="(n/$last)*(n/$last)*(3-2*(n/$last))"
  local xexpr="$x0+($x1-$x0)*$ease+1.4*sin(n*0.37)"
  local yexpr="$y0+($y1-$y0)*$ease+1.1*sin(n*0.29+0.8)"

  "$FFMPEG_BIN" -hide_banner -loglevel error -y \
    -loop 1 -framerate "$FPS" -i "$BASE/plates/$src" \
    -vf "scale=$sw:$sh:flags=lanczos,crop=1920:1080:x='$xexpr':y='$yexpr',eq=contrast=1.012:saturation=1.018,setsar=1,format=yuv420p" \
    -frames:v "$frames" -an -r "$FPS" \
    -c:v libx264 -preset slow -crf 16 -profile:v high -level 4.1 \
    -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
    -movflags +faststart "$BASE/clips/$out"
}

# 2.4 s title move across the physically fixed show name on the panel.
render_move 02_panel_side_branded.jpg 01_panel_title_slider.mp4 60 3200 1800 1268 1060 710 648

# 2.4 s vertical tilt from lighting truss to microphone and performance floor.
render_move 05_clean_stage_master.jpg 02_stage_tilt_down.mp4 60 2304 1296 192 192 4 210

# 2.4 s fast slider along the five empty judge chairs and desk microphones.
render_move 04_desk_close_branded.jpg 03_five_seat_desk_slider.mp4 60 2688 1512 8 720 420 344

# 2.4 s diagonal crane-style descent through the full room.
render_move 01_wide_branded_panel.jpg 04_full_room_crane_drop.mp4 60 2304 1296 76 302 8 204

# 2.4 s high-angle diagonal sweep across the unchanged set geometry.
render_move 06_overhead_branded.jpg 05_overhead_diagonal.mp4 60 2304 1296 4 378 210 8

# 2.4 s stage-level lateral move from judges' panel toward the microphone.
render_move 03_stage_front_branded.jpg 06_panel_to_microphone.mp4 60 2304 1296 5 378 112 104

# 1.2 s punchy close panel-title insert.
render_move 03_stage_front_branded.jpg 07_panel_title_insert.mp4 30 3600 2025 2 150 900 790

# 1.2 s emblem detail with a short diagonal arc.
render_move 03_stage_front_branded.jpg 08_emblem_detail.mp4 30 3200 1800 692 1010 42 286

# 1.2 s microphone detail moving laterally rather than zooming.
render_move 03_stage_front_branded.jpg 09_microphone_detail.mp4 30 3200 1800 1240 1070 278 352

# 1.8 s reveal across all five judge chairs.
render_move 02_panel_side_branded.jpg 10_five_chair_reveal.mp4 45 2688 1512 8 286 404 256

# 1.8 s audience-level sweep of the clean stage master.
render_move 05_clean_stage_master.jpg 11_audience_master_sweep.mp4 45 2304 1296 8 376 110 96

# 3.0 s closing rise into the complete branded room.
render_move 01_wide_branded_panel.jpg 12_finale_crane_rise.mp4 75 2304 1296 300 82 205 22

printf 'Rendered dynamic clips to %s\n' "$BASE/clips"
