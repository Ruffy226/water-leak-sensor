# Water Leak Sensor - Wiring Guide

## Overview

The UHPPOTE water probe is a **contact sensor** that acts like a switch. When water is detected, the contacts close. This is wired to the ESP32 as a binary sensor with a pull-up resistor.

## Components

| Component | Pin | Connection |
|-----------|-----|------------|
| Xiao ESP32-S3 | - | Main controller |
| UHPPOTE Probe COM | GND | Common terminal |
| UHPPOTE Probe NO | GPIO1 (D0/A0) | Normally Open terminal |
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
    ┌─────────────────┐
    │  Xiao ESP32-S3  │
    │                 │
    │  3.3V           │
    │    │            │
    │  [10kΩ]         │ ← Internal pull-up (enabled in software)
    │    │            │
    │  GPIO1 ─────────┼──── Probe NO
    │                 │
    │  GND ───────────┼──── Probe COM
    │                 │
    │  GPIO2 ─────────┼──── LED (+)
    │                 │
    │  GND ───[220Ω]──┼──── LED (-)
    │                 │
    │  USB-C ─────────┤     Power
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

## How It Works

### Normal State (No Water)
- Probe contacts are OPEN (no connection)
- Internal pull-up resistor keeps GPIO1 HIGH
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
5. **Secure with hot glue** — Optional strain relief

## LED Selection

Any standard LED will work:
- Red is typical for alerts
- Forward voltage: ~2V
- Current: 10-20mA (220Ω resistor limits current)

## Testing

1. Flash ESPHome config to Xiao
2. Power via USB-C
3. Touch probe contacts with damp cloth or immerse in water
4. LED should light up
5. Check Home Assistant for "Water Leak" sensor state

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| False triggers | Probe wires shorting | Check wiring, ensure no contact between wires |
| No detection | Wrong terminals used | Use COM and NO (not NC) |
| LED doesn't light | Wrong polarity | Flip LED connections |
| Won't boot | GPIO shorted to GND | Check probe wiring |

## Safety

- USB power is low voltage (5V) — safe around water
- Keep USB port above potential flood level
- Mount sensor higher than probe
- Probe should be at lowest point where water collects
