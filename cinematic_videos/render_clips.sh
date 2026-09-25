#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/cinematic_videos"
FPS=24

if [[ -n "${FFMPEG:-}" ]]; then
  FFMPEG_BIN="$FFMPEG"
elif command -v ffmpeg >/dev/null 2>&1; then
  FFMPEG_BIN="$(command -v ffmpeg)"
elif python -c 'import imageio_ffmpeg' >/dev/null 2>&1; then
  FFMPEG_BIN="$(python -c 'import imageio_ffmpeg; print(imageio_ffmpeg.get_ffmpeg_exe())')"
else
  echo "ffmpeg was not found. Install ffmpeg or Python's imageio-ffmpeg package." >&2
  exit 1
fi

mkdir -p "$OUT/clips"

render() {
  local source="$1"
  local output="$2"
  local frames="$3"
  local zoom="$4"
  local xpos="$5"
  local ypos="$6"

  "$FFMPEG_BIN" -hide_banner -loglevel error -y \
    -loop 1 -framerate "$FPS" -i "$source" \
    -vf "scale=3840:2160:flags=lanczos,zoompan=z='$zoom':x='$xpos':y='$ypos':d=1:s=1920x1080:fps=$FPS,eq=contrast=1.015:saturation=1.025,setsar=1,format=yuv420p" \
    -frames:v "$frames" -an \
    -c:v libx264 -preset slow -crf 17 -profile:v high -level 4.1 \
    -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
    -movflags +faststart "$OUT/clips/$output"
}

# 6.0 seconds — slow central push into the full room.
render \
  "$ROOT/cinematic_shots/trailer_ready_1080p/01_grand_establishing.jpg" \
  "01_establishing_push.mp4" 144 \
  "1.02+0.08*on/143" \
  "iw/2-(iw/zoom/2)" \
  "ih/2-(ih/zoom/2)"

# 5.0 seconds — stronger aisle dolly toward the lone stage microphone.
render \
  "$ROOT/cinematic_shots/trailer_ready_1080p/02_aisle_push_in.jpg" \
  "02_center_aisle_dolly.mp4" 120 \
  "1.03+0.11*on/119" \
  "iw/2-(iw/zoom/2)" \
  "ih/2-(ih/zoom/2)"

# 6.0 seconds — lateral move along exactly five judge positions.
render \
  "$OUT/keyframes/03_five_judge_panel.jpg" \
  "03_five_judge_panel_glide.mp4" 144 \
  "1.14" \
  "(iw-iw/zoom)*on/143" \
  "ih/2-(ih/zoom/2)"

# 6.0 seconds — high-angle crane-style pullback.
render \
  "$ROOT/cinematic_shots/trailer_ready_1080p/04_crane_overhead.jpg" \
  "04_crane_pullback.mp4" 144 \
  "1.13-0.10*on/143" \
  "iw/2-(iw/zoom/2)" \
  "ih/2-(ih/zoom/2)"

# 5.0 seconds — drift away from the curtain to reveal the stage and panel.
render \
  "$ROOT/cinematic_shots/trailer_ready_1080p/05_curtain_reveal.jpg" \
  "05_curtain_reveal.mp4" 120 \
  "1.12" \
  "(iw-iw/zoom)*(1-on/119)" \
  "ih/2-(ih/zoom/2)"

# 4.0 seconds — tight hero push on the performance microphone.
render \
  "$ROOT/cinematic_shots/trailer_ready_1080p/06_microphone_hero.jpg" \
  "06_microphone_hero.mp4" 96 \
  "1.02+0.14*on/95" \
  "(iw-iw/zoom)*0.72" \
  "ih/2-(ih/zoom/2)"

# 6.0 seconds — energetic final pullback with the complete room illuminated.
render \
  "$ROOT/cinematic_shots/trailer_ready_1080p/08_lights_up_finale.jpg" \
  "07_lights_up_finale.mp4" 144 \
  "1.12-0.10*on/143" \
  "iw/2-(iw/zoom/2)" \
  "ih/2-(ih/zoom/2)"

printf 'Rendered clips to %s\n' "$OUT/clips"
