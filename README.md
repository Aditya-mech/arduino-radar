# arduino-radar
Arduino Uno radar system with a servo-mounted ultrasonic sensor, laptop display, and buzzer alert

## Parts
- Arduino Uno
- Servo motor (SG90)
- HC-SR04 ultrasonic sensor
- Buzzer
- Breadboard and jumper wires

## Wiring
| Part | Part pin | Arduino pin |
|------|----------|-------------|
| HC-SR04 | Trig | 9 |
| HC-SR04 | Echo | 10 |
| Servo | Signal | 11 |
| Buzzer | + | 8 |
| All parts | VCC / GND | 5V / GND |

The HC-SR04 is mounted on the servo horn so it sweeps with it.

## How it works
The servo sweeps the ultrasonic sensor back and forth (15° to 165°). The Arduino measures the distance at each angle and sends `angle,distance.` over serial at 9600 baud. The Processing sketch reads that data and draws the radar screen, and the buzzer sounds when an object is closer than 20 cm.

## How to run
1. Upload `arduino_radar/arduino_radar.ino` to the Arduino.
2. Close the Arduino serial monitor.
3. Open `radar_display/radar_display.pde` in Processing and press Run. If the wrong serial port is picked, change `PORT_INDEX` at the top of the sketch.

## Folder layout
- `arduino_radar/` - Arduino sketch
- `radar_display/` - Processing sketch for the laptop display
