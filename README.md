# Water Leak Sensor

## Overview
USB-powered water leak sensor using Xiao ESP32-S3 with UHPPOTE wired water probe. Detects water via contact closure and sends alerts to Home Assistant via ESPHome/WiFi.

## Features
- 🔌 USB-C powered (always on)
- 💧 UHPPOTE wired water probe (contact sensor)
- 📡 WiFi connectivity to Home Assistant
- 🔔 Instant alerts when leak detected
- 🧲 Magnetic mounting (optional)
- 📊 Battery-free design (no maintenance)

## Hardware

| Component | Status | Price | Notes |
|-----------|--------|-------|-------|
| Xiao ESP32-S3 | ✅ Have | - | Main MCU |
| UHPPOTE Water Probe | ✅ Have | ~$10 | [Amazon 5-pack](https://www.amazon.com/dp/B07L94MMP7) |
| USB-C cable | ✅ Have | - | Power only |
| LED (red) | ✅ Have | - | Local alert indicator |
| Magnetic latch | ✅ Have | - | Mounting bracket |
| Case | ⏳ Design | - | 3D printed |

## UHPPOTE Water Probe

This is a **contact sensor** that acts like a switch:
- **Dry contacts** — No voltage needed at the probe
- **Opens/closes** based on water detection
- **Screw terminals** — Easy wiring
- **Mounting tab** — Keyhole for screw mounting

**How it works:**
- When dry: contacts are **OPEN** (no connection)
- When wet: contacts **CLOSE** (short circuit)
- Connects to ESP32 as a binary sensor

## Wiring

```
                    ┌─────────────────┐
                    │  Xiao ESP32-S3  │
                    │                 │
    Probe COM ──────┤ GND             │
                    │                 │
    Probe NO ───────┤ GPIO1 (A0)      │
                    │    [10kΩ to     │
                    │     3.3V]       │
                    │                 │
    LED (+) ────────┤ GPIO2           │
    LED (-) ─[220Ω]─┤ GND             │
                    │                 │
    USB-C ──────────┤ 5V / GND        │
                    └─────────────────┘

UHPPOTE Probe:
  COM ─── Common (connect to GND)
  NO  ─── Normally Open (connect to GPIO with pull-up)
  NC  ─── Normally Closed (not used)
```

## Installation Locations

- Under sink cabinets
- Near water heater
- Washing machine
- Dishwasher
- Sump pump area
- Basement floor

## ESPHome Config

See `water-leak-sensor.yaml`

## Home Assistant Automation

```yaml
automation:
  - alias: "Water Leak Alert"
    trigger:
      - platform: state
        entity_id: binary_sensor.water_leak_sensor
        to: "on"
    action:
      - service: notify.mobile_app_your_phone
        data:
          message: "⚠️ WATER LEAK DETECTED!"
          title: "Water Leak Alert"
      - service: light.turn_on
        target:
          entity_id: light.alert_lights
        data:
          color_name: red
```

## Case Design

- Small enclosure with probe wires exiting bottom
- USB-C port on back or side
- LED indicator visible from top
- Magnetic mount on back
- Probe can be placed on floor, sensor mounted higher

## Files

- `water-leak-sensor.yaml` — ESPHome configuration
- `case.scad` — OpenSCAD case design
- `wiring.md` — Detailed wiring instructions

## Cost

~$10-15 total (assuming you have the Xiao ESP32-S3)

## Next Steps

- [x] UHPPOTE probe obtained
- [ ] Wire to Xiao ESP32-S3
- [ ] Flash ESPHome config
- [ ] Test water detection
- [ ] Print case
- [ ] Install under sink
