# Water Leak Sensor - Wiring Guide

## Overview

The water leak sensor uses a simple conductive probe to detect water. When water bridges the two probe pins, the circuit completes and the ESP32 detects the change.

## Components

| Component | Pin | Connection |
|-----------|-----|------------|
| Xiao ESP32-S3 | - | Main controller |
| Probe Pin A | GPIO1 (D0/A0) | Water detection input |
| Probe Pin B | GND | Ground reference |
| 1MΩ Resistor | GPIO1 → 3.3V | Pull-up resistor |
| LED Anode (+) | GPIO2 | Alert indicator |
| LED Cathode (-) | GND (via 220Ω) | Current limiting |
| USB-C | 5V / GND | Power only |

## Schematic

```
                    3.3V
                     │
                   [1MΩ]
                     │
    ┌────────────────┼────────────────┐
    │                │                │
    │   Xiao ESP32-S3                │
    │                │                │
    │  GPIO1 ────────┼──── Probe A    │  ←── Water Detection
    │                │                │
    │  GND ──────────┼──── Probe B    │
    │                │                │
    │  GPIO2 ────────┼──── LED (+)    │  ←── Alert LED
    │                │                │
    │  GND ───[220Ω]┼──── LED (-)     │
    │                │                │
    │  5V/GND ───────┼──── USB-C      │  ←── Power
    │                │                │
    └────────────────┴────────────────┘

    WATER DETECTED:
    ──────────────
    [Probe A] ── water ── [Probe B]
         │                   │
         └──── GPIO1 ────────┘
              (pulled LOW)
```

## How It Works

### Normal State (No Water)
- 1MΩ resistor pulls GPIO1 HIGH (3.3V)
- Probe pins are open circuit (no connection)
- ESP32 reads GPIO1 as HIGH
- LED is OFF

### Water Detected
- Water bridges Probe A and Probe B
- Water conductivity pulls GPIO1 LOW
- ESP32 reads GPIO1 as LOW
- LED turns ON
- Alert sent to Home Assistant

## Probe Construction

### Option 1: PCB Header Pins (Recommended)
```
    │ │    ← Two adjacent pins from a standard 0.1" header
    │ │
    └─┘    ← Break off a 2-pin section
```
- Cheap and easy
- Solder wires directly to pins
- Space 5-10mm apart

### Option 2: Exposed Wire
- Use stainless steel wire (corrosion resistant)
- Strip 10mm of insulation
- Solder to GPIO and GND
- Secure with hot glue

### Option 3: Screw Terminals
- Allows remote probe placement
- Run wires to where water might collect
- Probe can be on floor, sensor mounted higher

## Resistor Selection

The 1MΩ pull-up resistor is critical:
- Too small: False triggers from humidity
- Too large: Slow response, may miss small leaks
- 1MΩ is a good balance for most situations

## LED Selection

Any standard LED will work:
- Red is typical for alerts
- Forward voltage: ~2V
- Current: 10-20mA (220Ω resistor limits current)

## Testing

1. Flash ESPHome config to Xiao
2. Power via USB-C
3. Touch probe pins with damp finger
4. LED should light up
5. Check Home Assistant for "Water Leak" sensor state

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| False triggers | Humidity, condensation | Increase resistor to 2MΩ |
| No detection | Resistor too large, probe too far apart | Reduce to 470kΩ, move pins closer |
| LED doesn't light | Wrong polarity | Flip LED connections |
| Won't boot | Short circuit on GPIO | Check probe wiring for shorts |

## Safety

- USB power is low voltage (5V) — safe around water
- Keep USB port away from potential flooding
- Mount sensor above expected water level
- Probe should be at lowest point where water collects
