# Cinematic video clips

Seven editor-ready motion shots of **The Habitat**, created from the reference set and cinematic keyframes. The judges’ panel is built around **exactly five judge positions**; no judge faces were invented because the repository currently contains only set references.

## Master preview

- `trailer_shots_preview.mp4` — 35.9-second review reel with short crossfades.
- `contact_sheet.jpg` — midpoint preview of every clip.

## Individual clips

| # | File | Duration | Camera move |
|---|---|---:|---|
| 01 | `clips/01_establishing_push.mp4` | 6 s | Slow central push into the full venue. |
| 02 | `clips/02_center_aisle_dolly.mp4` | 5 s | Audience-aisle dolly toward the stage microphone. |
| 03 | `clips/03_five_judge_panel_glide.mp4` | 6 s | Lateral glide along all five judge positions. |
| 04 | `clips/04_crane_pullback.mp4` | 6 s | High-angle crane-style pullback. |
| 05 | `clips/05_curtain_reveal.mp4` | 5 s | Backstage curtain drift revealing the set. |
| 06 | `clips/06_microphone_hero.mp4` | 4 s | Tight push onto the performance microphone. |
| 07 | `clips/07_lights_up_finale.mp4` | 6 s | Illuminated finale pullback. |

## Technical format

- H.264 High Profile MP4
- 1920 × 1080, square pixels, 16:9
- 24 fps, progressive, BT.709, `yuv420p`
- Silent, so the clips can be cut against the trailer’s final music and sound design
- Clean clips have no baked transitions; transitions appear only in the preview reel

`render_clips.sh` reproduces all seven individual clips when FFmpeg is available.
