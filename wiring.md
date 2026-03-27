# Water Leak Sensor - Wiring Guide

## Overview

The UHPPOTE water probe is a **contact sensor** that acts like a switch. When water is detected, the contacts close. This is wired to the ESP32 as a binary sensor with a pull-up resistor.

## Components

| Component | Pin | Connection |
|-----------|-----|------------|
| Xiao ESP32-S3 | - | Main controller |
| UHPPOTE Probe COM | GND | Common terminal |
| UHPPOTE Probe NO | GPIO1 (D0/A0) | Normally Open terminal |
| Pull-up resistor | 4.7kΩ | GPIO1 → 3.3V (noise immunity) |
| Capacitor (optional) | 0.1µF | GPIO1 → GND (debounce) |
| LED Anode (+) | GPIO2 | Alert indicator |
| LED Cathode (-) | GND (via 220Ω) | Current limiting |
| USB-C | 5V / GND | Power only |

## UHPPOTE Probe Terminals

The probe has 3 terminals:

| Terminal | Name | Description |
|----------|------|-------------|
| COM | Common | Connect to GND |
| NO | Normally Open | Connects to COM when water detected |
| NC | Normally Closed | Disconnects from COM when water detected (not used) |

**Use COM and NO** for water leak detection.

## Schematic

```
                    3.3V
                     │
                  [4.7kΩ] ← External pull-up (recommended)
                     │
    ┌────────────────┼────────────────┐
    │                │                │
    │   Xiao ESP32-S3                │
    │                │                │
    │  GPIO1 ─────────┼──── Probe NO  │
    │    │            │               │
    │  [0.1µF]        │  ← Optional debounce capacitor
    │    │            │               │
    │  GND ───────────┼──── Probe COM │
    │                 │               │
    │  GPIO2 ─────────┼──── LED (+)   │
    │                 │               │
    │  GND ───[220Ω]──┼──── LED (-)   │
    │                 │               │
    │  USB-C ─────────┤     Power     │
    └─────────────────┘

    UHPPOTE Probe:
    ┌─────────────┐
    │  NC  COM NO │
    │   ○   ○  ○  │
    │      │  └───┼── GPIO1 (with pull-up)
    │      └──────┼── GND
    └─────────────┘

    WATER DETECTED:
    ──────────────
    NO connects to COM → GPIO1 pulled LOW → Alert triggered
```

## Why the External Resistor?

The ESP32 has an **internal pull-up** (~10kΩ-45kΩ), but an **external 4.7kΩ resistor** provides:

1. **Stronger pull-up** — Better noise immunity on long wires
2. **Faster response** — Lower RC time constant
3. **Defined voltage** — Less susceptible to EMI

**When to add the capacitor (0.1µF):**
- Long probe wires (>1 meter)
- Electrically noisy environment
- Persistent false triggers

The capacitor filters fast transients but slows response slightly (~1-5ms).

## How It Works

### Normal State (No Water)
- Probe contacts are OPEN (no connection)
- Pull-up resistor keeps GPIO1 HIGH (3.3V)
- ESP32 reads GPIO1 as HIGH
- LED is OFF

### Water Detected
- Probe contacts CLOSE (NO connects to COM)
- GPIO1 is pulled LOW via connection to GND
- ESP32 reads GPIO1 as LOW
- LED turns ON
- Alert sent to Home Assistant

## Wiring the UHPPOTE Probe

1. **Strip wires** — Remove ~5mm insulation from probe wires
2. **Loosen screws** — On COM and NO terminals
3. **Insert wires** — COM → GND wire, NO → GPIO1 wire
4. **Tighten screws** — Secure connections
5. **Add resistor** — Solder 4.7kΩ between GPIO1 and 3.3V (on perfboard or directly)
6. **Optional capacitor** — Add 0.1µF between GPIO1 and GND if noisy
7. **Secure with hot glue** — Strain relief for wires

## Component Selection

| Component | Value | Purpose |
|-----------|-------|---------|
| Pull-up resistor | 4.7kΩ | Noise immunity, reliable detection |
| Debounce capacitor | 0.1µF (100nF) | Filters electrical noise |
| LED resistor | 220Ω | Limits current to ~10mA |

**Resistor alternatives:**
- 1kΩ — Maximum noise immunity (uses more current)
- 4.7kΩ — Good balance (recommended)
- 10kΩ — Lower power, less noise immunity

## Testing

1. Flash ESPHome config to Xiao
2. Power via USB-C
3. Touch probe contacts with damp cloth or immerse in water
4. LED should light up
5. Check Home Assistant for "Water Leak" sensor state

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| False triggers | EMI, long wires | Add 4.7kΩ pull-up + 0.1µF capacitor |
| Slow response | Capacitor too large | Reduce to 0.01µF or remove |
| No detection | Wrong terminals | Use COM and NO (not NC) |
| LED doesn't light | Wrong polarity | Flip LED connections |
| Won't boot | GPIO shorted | Check probe wiring |

## Safety

- USB power is low voltage (5V) — safe around water
- Keep USB port above potential flood level
- Mount sensor higher than probe
- Probe should be at lowest point where water collects
