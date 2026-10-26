import argparse
import ctypes
import sys
import time
from datetime import datetime
from pathlib import Path

import pyautogui
from PIL import ImageDraw, ImageGrab

pyautogui.FAILSAFE = True

SCREENSHOT_DIR = Path(__file__).resolve().parent / "screenshots"
MIN_DELAY = 0.5


class _MONITORINFO(ctypes.Structure):
    _fields_ = [
        ("cbSize", ctypes.c_ulong),
        ("rcMonitor", ctypes.c_long * 4),
        ("rcWork", ctypes.c_long * 4),
        ("dwFlags", ctypes.c_ulong),
    ]


MONITORINFOF_PRIMARY = 0x1


def _enum_monitors():
    """Return a list of (left, top, right, bottom, is_primary) for every
    connected monitor, in Windows virtual-screen coordinates."""
    monitors = []

    MonitorEnumProc = ctypes.WINFUNCTYPE(
        ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.POINTER(ctypes.c_long * 4), ctypes.c_double
    )

    def _callback(hmonitor, hdc, lprect, lparam):
        info = _MONITORINFO()
        info.cbSize = ctypes.sizeof(_MONITORINFO)
        ctypes.windll.user32.GetMonitorInfoW(hmonitor, ctypes.byref(info))
        rect = info.rcMonitor
        is_primary = bool(info.dwFlags & MONITORINFOF_PRIMARY)
        monitors.append((rect[0], rect[1], rect[2], rect[3], is_primary))
        return 1

    callback = MonitorEnumProc(_callback)
    ctypes.windll.user32.EnumDisplayMonitors(0, 0, callback, 0)
    return monitors


def get_secondary_monitor_rect():
    """Return (left, top, right, bottom) of the first non-primary monitor,
    falling back to the primary (or (0,0,W,H)) if there's only one."""
    monitors = _enum_monitors()
    if not monitors:
        w, h = pyautogui.size()
        return (0, 0, w, h)
    for left, top, right, bottom, is_primary in monitors:
        if not is_primary:
            return (left, top, right, bottom)
    left, top, right, bottom, _ = monitors[0]
    return (left, top, right, bottom)


def grab_secondary_monitor():
    """Capture only the secondary display (where SolidWorks lives on this
    machine), in its own virtual-screen coordinate space. Returns
    (image, (offset_x, offset_y)) — add the offset to any x,y read off this
    image before passing it to pyautogui.click, since the image's (0,0) is
    not necessarily the real screen's (0,0) on a multi-monitor setup."""
    left, top, right, bottom = get_secondary_monitor_rect()
    img = ImageGrab.grab(bbox=(left, top, right, bottom), all_screens=True)
    return img, (left, top)


def _ts(tag=None):
    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return f"{stamp}_{tag}" if tag else stamp


def _save_path(tag=None, suffix=""):
    SCREENSHOT_DIR.mkdir(parents=True, exist_ok=True)
    name = f"{_ts(tag)}{suffix}.png"
    return SCREENSHOT_DIR / name


def take_screenshot(tag=None, suffix=""):
    path = _save_path(tag, suffix)
    img, _offset = grab_secondary_monitor()
    img.save(path)
    return path


def cmd_shot(args):
    path = take_screenshot(args.tag)
    print(str(path))


def cmd_mark(args):
    # x,y here are coordinates WITHIN the secondary-monitor screenshot image
    # (i.e. exactly what you read off a saved PNG) — no offset math needed
    # by the caller.
    img, _offset = grab_secondary_monitor()
    draw = ImageDraw.Draw(img)
    x, y, r = args.x, args.y, args.radius
    draw.ellipse((x - r, y - r, x + r, y + r), outline="red", width=3)
    draw.line((x - r * 1.5, y, x + r * 1.5, y), fill="red", width=2)
    draw.line((x, y - r * 1.5, x, y + r * 1.5), fill="red", width=2)
    label = f"({x},{y})"
    draw.text((x + r + 4, y - r - 14), label, fill="red")
    path = _save_path(args.tag, suffix="_preview")
    img.save(path)
    print(str(path))


def countdown(seconds):
    seconds = max(seconds, MIN_DELAY)
    print(f"Acting in {seconds}s — move mouse to any screen corner to abort (failsafe).")
    whole = int(seconds)
    remainder = seconds - whole
    for i in range(whole, 0, -1):
        print(f"  {i}...")
        time.sleep(1)
    if remainder > 0:
        time.sleep(remainder)


def run_guarded(action_desc, delay, action_fn, tag=None):
    print(action_desc)
    countdown(delay)
    try:
        action_fn()
    except pyautogui.FailSafeException:
        print("ABORTED by failsafe — mouse moved to screen corner.")
        sys.exit(1)
    path = take_screenshot(tag, suffix="_after")
    print(f"Action complete. After-action screenshot: {path}")


def _to_screen_coords(x, y):
    """Convert image-pixel coords (secondary-monitor screenshot) to real
    Windows virtual-screen coords for pyautogui."""
    off_x, off_y = get_secondary_monitor_rect()[:2]
    return x + off_x, y + off_y


def cmd_click(args):
    btn = args.button
    sx, sy = _to_screen_coords(args.x, args.y)
    desc = (
        f"About to {'double-' if args.double else ''}click image-coords ({args.x}, {args.y}) "
        f"= screen-coords ({sx}, {sy}) with {btn} button."
    )

    def action():
        if args.double:
            pyautogui.doubleClick(sx, sy, button=btn)
        else:
            pyautogui.click(sx, sy, button=btn)

    run_guarded(desc, args.delay, action, args.tag)


def cmd_type(args):
    desc = f"About to type: {args.text!r}"

    def action():
        pyautogui.typewrite(args.text, interval=0.03)

    run_guarded(desc, args.delay, action, args.tag)


def cmd_hotkey(args):
    desc = f"About to send hotkey: {' + '.join(args.keys)}"

    def action():
        pyautogui.hotkey(*args.keys)

    run_guarded(desc, args.delay, action, args.tag)


def cmd_scroll(args):
    desc = f"About to scroll {args.amount} at ({args.x}, {args.y})"

    def action():
        if args.x is not None and args.y is not None:
            sx, sy = _to_screen_coords(args.x, args.y)
            pyautogui.moveTo(sx, sy)
        pyautogui.scroll(args.amount)

    run_guarded(desc, args.delay, action, args.tag)


def build_parser():
    p = argparse.ArgumentParser(prog="sw_assist.py")
    sub = p.add_subparsers(dest="command", required=True)

    s = sub.add_parser("shot", help="Take a screenshot (read-only)")
    s.add_argument("--tag")
    s.set_defaults(func=cmd_shot)

    m = sub.add_parser("mark", help="Preview a click target (read-only)")
    m.add_argument("x", type=int)
    m.add_argument("y", type=int)
    m.add_argument("--tag")
    m.add_argument("--radius", type=int, default=18)
    m.set_defaults(func=cmd_mark)

    c = sub.add_parser("click", help="Click at pixel coordinates")
    c.add_argument("x", type=int)
    c.add_argument("y", type=int)
    c.add_argument("--tag")
    c.add_argument("--button", choices=["left", "right"], default="left")
    c.add_argument("--double", action="store_true")
    c.add_argument("--delay", type=float, default=1.5)
    c.set_defaults(func=cmd_click)

    t = sub.add_parser("type", help="Type literal text")
    t.add_argument("text")
    t.add_argument("--tag")
    t.add_argument("--delay", type=float, default=1.5)
    t.set_defaults(func=cmd_type)

    h = sub.add_parser("hotkey", help="Send a key combo, e.g. ctrl s")
    h.add_argument("keys", nargs="+")
    h.add_argument("--tag")
    h.add_argument("--delay", type=float, default=1.5)
    h.set_defaults(func=cmd_hotkey)

    sc = sub.add_parser("scroll", help="Scroll the mouse wheel")
    sc.add_argument("amount", type=int)
    sc.add_argument("--x", type=int)
    sc.add_argument("--y", type=int)
    sc.add_argument("--tag")
    sc.add_argument("--delay", type=float, default=1.5)
    sc.set_defaults(func=cmd_scroll)

    return p


def main():
    parser = build_parser()
    args = parser.parse_args()
    if hasattr(args, "delay") and args.delay < MIN_DELAY:
        args.delay = MIN_DELAY
    args.func(args)


if __name__ == "__main__":
    main()
