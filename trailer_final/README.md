# Backbencher's Got Talent — final cinematic package

This version stays locked to the six original images in [`../set`](../set): the same curtain layout, ring emblem, glossy stage, audience geometry, microphone, and **five-seat judges' panel**. No camera operators or redesigned rooms are introduced.

The exact show name, **BACKBENCHER'S GOT TALENT**, is perspective-composited onto the physical front face of the judges' panel.

## Finished videos

- `backbenchers_intro.mp4` — 9.6-second opening ident.
  - Uses `res/BACKBENCHERS! (1).mp3`.
  - Opens on the fixed, branded judges' panel before revealing the stage.
- `backbenchers_trailer.mp4` — 36-second trailer sequence.
  - Uses `res/BACKBENCHERS!.mp3`.
  - Cut on a 100-BPM grid with hard, energetic edits.

Both masters are H.264/AAC MP4, 1920 × 1080, 25 fps, progressive, BT.709, with 48 kHz stereo audio.

## Shot pack

`clips/` contains 12 clean editor-ready shots:

1. Panel title slider
2. Stage tilt down
3. Five-seat desk slider
4. Full-room crane drop
5. Overhead diagonal
6. Panel-to-microphone lateral move
7. Panel title insert
8. Emblem detail
9. Microphone detail
10. Five-chair reveal
11. Audience master sweep
12. Finale crane rise

The motion is built from fixed-scale pans, tilts, lateral sliders, and diagonal crane-style moves—not slow synthetic zooms.

## Supporting files

- `plates/` — six 1080p set-faithful master plates.
- `intro_contact.jpg` and `trailer_contact.jpg` — visual QC sheets.
- `render.sh` — reproducibly renders the 12 dynamic clips.
- `assemble.sh` — assembles the intro and trailer with the supplied songs.
