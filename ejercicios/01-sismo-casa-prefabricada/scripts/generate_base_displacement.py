"""Generate the 2-component horizontal ground displacement used to drive the
base block of the earthquake model (ANSYS Transient Structural, Displacement
boundary condition with Tabular Data).

Component 1 (global X) uses the same synthetic accelerogram as
generate_accelerogram.py (seed 42, same scale, PGA 3.43 m/s^2). Component 2
(global Z, horizontal) is an independent synthetic record (seed 7) scaled to
0.85 x PGA, the usual ratio between the two horizontal components of a record.

The accelerations are rebuilt at a fine step, integrated twice and baseline
corrected (zero-phase high-pass at 0.1 Hz + cosine end tapers) so the base
starts and ends at rest without drift. The first T_GRAVITY seconds are zero:
that load step is used only to settle gravity before the shaking starts.

NOT a real record. For reportable work, replace with a digitized record
(PEER NGA-West2 or the local strong-motion network).
"""
import csv
import math
import random

import numpy as np
from scipy.signal import butter, filtfilt

T_END = 15.0          # s, duration of the shaking
T_GRAVITY = 1.0       # s, gravity-only load step before the shaking
DT_FINE = 0.005       # s, integration step
DT_OUT = 0.05         # s, step of the ANSYS table
PGA_X = 3.43          # m/s^2 (~0.35 g)
PGA_Z = 0.85 * PGA_X  # m/s^2, second horizontal component
FREQS = [0.4, 0.8, 1.3, 1.9, 2.6, 3.4, 4.3, 5.3, 6.4, 7.6, 8.9, 10.3, 11.8, 13.4, 15.1]
WEIGHTS = [1.0, 0.95, 0.85, 0.75, 0.65, 0.55, 0.45, 0.38, 0.30, 0.24, 0.18, 0.13, 0.09, 0.06, 0.04]


def envelope(t):
    return np.where(t < 2.0, (t / 2.0) ** 1.5, np.where(t < 10.0, 1.0, np.exp(-0.6 * (t - 10.0))))


def component(seed, pga, t, scale_dt):
    random.seed(seed)
    phases = [random.uniform(0, 2 * math.pi) for _ in FREQS]

    def raw(tt):
        s = sum(w * np.sin(2 * np.pi * f * tt + p) for w, f, p in zip(WEIGHTS, FREQS, phases))
        return envelope(tt) * s

    # scale exactly as generate_accelerogram.py does (peak of the 0.15 s samples)
    t_coarse = np.arange(0.0, T_END + 1e-9, scale_dt)
    scale = pga / np.max(np.abs(raw(t_coarse)))
    return scale * raw(t)


def to_displacement(acc, dt):
    b, a = butter(4, 0.1, btype="highpass", fs=1.0 / dt)
    n = len(acc)
    taper = np.ones(n)
    m = int(1.0 / dt)                                   # 1 s cosine tapers
    taper[:m] = 0.5 * (1 - np.cos(np.pi * np.arange(m) / m))
    taper[-m:] = taper[:m][::-1]
    acc = filtfilt(b, a, acc * taper)
    vel = np.concatenate([[0.0], np.cumsum((acc[1:] + acc[:-1]) * dt / 2)])
    vel = filtfilt(b, a, vel) * taper
    disp = np.concatenate([[0.0], np.cumsum((vel[1:] + vel[:-1]) * dt / 2)])
    disp = filtfilt(b, a, disp) * taper
    return acc, vel, disp


t = np.arange(0.0, T_END + 1e-9, DT_FINE)
ax, vx, ux = to_displacement(component(42, PGA_X, t, 0.15), DT_FINE)
az, vz, uz = to_displacement(component(7, PGA_Z, t, 0.15), DT_FINE)

step = int(round(DT_OUT / DT_FINE))
rows = [(0.0, 0.0, 0.0), (T_GRAVITY, 0.0, 0.0)]
rows += [(T_GRAVITY + ti, x, z) for ti, x, z in zip(t[step::step], ux[step::step], uz[step::step])]

out_path = "base_displacement_xz.csv"
with open(out_path, "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["Time [s]", "Ux [m]", "Uz [m]"])
    for ti, x, z in rows:
        w.writerow([f"{ti:.3f}", f"{x:.6f}", f"{z:.6f}"])

print(f"Wrote {len(rows)} rows to {out_path}")
for name, a, v, u in (("X", ax, vx, ux), ("Z", az, vz, uz)):
    print(f"{name}: PGA={np.max(np.abs(a)):.2f} m/s^2  PGV={np.max(np.abs(v)):.3f} m/s  "
          f"PGD={np.max(np.abs(u)) * 100:.2f} cm  final u={u[-1] * 1000:.3f} mm")
