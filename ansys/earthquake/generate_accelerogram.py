"""Generate a synthetic strong-motion accelerogram CSV for ANSYS Mechanical
Tabular Data import (Time [s], Acceleration [m/s^2]).

NOT a digitized real record. Modeled on the El Centro 1940 (Imperial Valley,
NS component) envelope shape: short rise, ~10s strong-motion phase, decay tail,
PGA scaled to ~0.35 g (~3.43 m/s^2), matching this project's 0-15s Transient
analysis time window. For rigorous/reportable work, replace with a real
digitized record from PEER NGA-West2 or a local strong-motion network.
"""
import csv
import math
import random

random.seed(42)

DT = 0.15           # s, matches solver Minimum Time Step (Analysis Settings)
T_END = 15.0        # s, matches the Transient (A5) analysis end time
PGA_TARGET = 3.43   # m/s^2 (~0.35 g), El Centro 1940 NS order of magnitude

# Envelope: fast rise (0-2s), sustained strong motion (2-10s), decay (10-15s)
def envelope(t):
    if t < 2.0:
        return (t / 2.0) ** 1.5
    elif t < 10.0:
        return 1.0
    else:
        return math.exp(-0.6 * (t - 10.0))

# Sum of damped sinusoids at frequencies typical of strong ground motion
# (roughly 0.5-8 Hz band), each with independent random phase, to avoid a
# pure-tone look while keeping a bounded, repeatable signal.
freqs = [0.4, 0.8, 1.3, 1.9, 2.6, 3.4, 4.3, 5.3, 6.4, 7.6, 8.9, 10.3, 11.8, 13.4, 15.1]
phases = [random.uniform(0, 2 * math.pi) for _ in freqs]
weights = [1.0, 0.95, 0.85, 0.75, 0.65, 0.55, 0.45, 0.38, 0.30, 0.24, 0.18, 0.13, 0.09, 0.06, 0.04]

def raw_signal(t):
    return sum(w * math.sin(2 * math.pi * f * t + p)
               for w, f, p in zip(weights, freqs, phases))

n_steps = int(round(T_END / DT))
times = [round(i * DT, 3) for i in range(n_steps + 1)]
raw = [envelope(t) * raw_signal(t) for t in times]

peak = max(abs(v) for v in raw)
scale = PGA_TARGET / peak
accel = [round(v * scale, 4) for v in raw]
accel[0] = 0.0
accel[-1] = round(accel[-1] * 0.05, 4)  # settle near zero at t_end

out_path = "synthetic_strong_motion_15s.csv"
with open(out_path, "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["Time [s]", "Acceleration [m/s^2]"])
    for t, a in zip(times, accel):
        w.writerow([f"{t:.3f}", f"{a:.4f}"])

print(f"Wrote {len(times)} rows to {out_path}")
print(f"Peak |accel| = {max(abs(a) for a in accel):.3f} m/s^2 at t = {times[accel.index(max(accel, key=abs))]} s")
