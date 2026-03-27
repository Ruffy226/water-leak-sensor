# Water Leak Sensor

## Overview
USB-powered water leak sensor using Xiao ESP32-S3. Detects water via conductive probes and sends alerts to Home Assistant via ESPHome/WiFi.

## Features
- 🔌 USB-C powered (always on)
- 💧 Water detection via conductive probes
- 📡 WiFi connectivity to Home Assistant
- 🔔 Instant alerts when leak detected
- 🧲 Magnetic mounting (optional)
- 📊 Battery-free design (no maintenance)

## Hardware

| Component | Status | Price | Notes |
|-----------|--------|-------|-------|
| Xiao ESP32-S3 | ✅ Have | - | Main MCU |
| USB-C cable | ✅ Have | - | Power only |
| Water probe pins | ⏳ Needed | ~$2 | PCB header pins or wire |
| 1MΩ resistor | ✅ Have | - | Pull-up for probe |
| LED (red) | ✅ Have | - | Local alert indicator |
| Magnetic latch | ✅ Have | - | Mounting bracket |
| Case | ⏳ Design | - | 3D printed |

## How It Works

Water is conductive. When water bridges the two probe pins:
1. Circuit completes between GPIO and GND
2. ESP32 detects the change
3. Sends alert to Home Assistant
4. LED lights up locally

## Wiring

```
                    ┌─────────────────┐
                    │  Xiao ESP32-S3  │
                    │                 │
    3.3V ───[1MΩ]───┤ GPIO1 (A0)      │
                    │                 │
    Probe A ────────┤ GPIO1           │
                    │                 │
    Probe B ────────┤ GND             │
                    │                 │
    LED (+) ────────┤ GPIO2           │
    LED (-) ─[220Ω]─┤ GND             │
                    │                 │
    USB-C ──────────┤ 5V / GND        │
                    └─────────────────┘

Probe pins should be:
- 5-10mm apart
- Exposed at bottom of case
- Gold-plated or nickel for corrosion resistance
```

## Probe Options

1. **PCB header pins** (cheapest) — Standard 0.1" header pins
2. **Screw terminals** — Allows external probe placement
3. **Exposed PCB traces** — Custom PCB with edge contacts
4. **Stainless steel wire** — Corrosion resistant

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

- Small enclosure with probe pins exposed at bottom
- USB-C port on back or side
- LED indicator visible from top
- Magnetic mount on back (uses your magnetic latch)
- Water should not pool inside case

## Files

- `water-leak-sensor.yaml` — ESPHome configuration
- `case.scad` — OpenSCAD case design
- `wiring.md` — Detailed wiring instructions

## Cost

~$5-10 total (assuming you have the Xiao ESP32-S3)

## Next Steps

- [ ] Order probe pins or decide on probe type
- [ ] Flash ESPHome config
- [ ] Test water detection
- [ ] Print case
- [ ] Install under sink
