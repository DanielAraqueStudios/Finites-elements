# sw_assist

Semi-automatic screen-assist tool for driving SolidWorks on a Windows machine,
ported from `INDUSTRIAL-AUTOMATION/scripts/tia_control/tia_assist.py` (same
operator-in-the-loop design). No blind autonomous clicking — every
mouse/keyboard action requires a visible countdown and leaves a
mouse-to-corner failsafe window open.

## Commands

- `shot [--tag NAME]` — screenshot now, read-only. Prints saved path.
- `mark X Y [--tag NAME] [--radius 18]` — screenshot with a red crosshair drawn
  at (X, Y), read-only, does not move the mouse. Use to confirm a target pixel
  before clicking it.
- `click X Y [--button left|right] [--double] [--delay 1.5]` — the only command
  that actually clicks. Prints what it's about to do, counts down (min 0.5s,
  default 1.5s), then clicks. Auto-screenshots after.
- `type "TEXT" [--delay 1.5]` — types literal text via the same countdown pattern.
- `hotkey KEY [KEY ...] [--delay 1.5]` — e.g. `hotkey ctrl s`.
- `scroll AMOUNT [--x X] [--y Y] [--delay 1.5]` — scroll wheel.

All acting commands (`click`/`type`/`hotkey`/`scroll`) print the countdown
every time — there is no way to skip it. `pyautogui.FAILSAFE` is on: slam the
mouse into any screen corner to abort immediately (raises `FailSafeException`,
caught and reported, exits nonzero).

## How Claude actually uses this

Claude Code has no live video feed of your screen — it can only see an image
after it's saved to disk and read back explicitly. The loop is:

1. Claude runs `shot` via the Bash tool → gets a saved PNG path.
2. Claude reads that PNG with its Read tool (it can view images directly).
3. Claude decides target coordinates from what it sees, runs `mark X Y`,
   reads that preview image to visually confirm the crosshair lands on the
   right button/field.
4. Only after confirming, Claude runs `click X Y` (or `type`/`hotkey`), then
   reads the automatic `_after` screenshot to verify the result before
   deciding the next step.

This is a real step-by-step loop (run → look → decide → run), not a one-shot
blind script — each click is visually confirmed before and after. It is slow
on purpose: one action per round-trip, same as the TIA Portal version.

## Risks specific to SolidWorks

- A misclick in a CAD feature tree can suppress/delete a feature, trigger an
  unwanted dialog, or leave a sketch half-edited — there is no "undo" built
  into this tool. Save your part (Ctrl+S) before starting an automated
  sequence, and periodically during one.
- Modal dialogs (error messages, confirm-to-exit-sketch prompts) can steal
  focus; always `shot` before assuming the previous click landed where
  expected, since the screen may show a dialog you didn't anticipate.
- Prefer the **macro recorder** (`Tools > Macro > Record`) for anything that
  needs to run repeatably/parametrically — it produces verified API calls
  (see `../README.md`), which is far more reliable than replaying
  fixed pixel coordinates. Use `sw_assist.py` for one-off exploration, not as
  a substitute for the macro.

## Run

```
py -3 ejercicios/04-estator-magnetostatico/cad/scripts/sw_assist.py shot
py -3 ejercicios/04-estator-magnetostatico/cad/scripts/sw_assist.py mark 640 400
py -3 ejercicios/04-estator-magnetostatico/cad/scripts/sw_assist.py click 640 400
```

## Setup

```
pip install pyautogui pillow
```
