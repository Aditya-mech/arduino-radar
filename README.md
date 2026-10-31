# arduino-radar
Arduino Uno radar system with a servo-mounted ultrasonic sensor, laptop display, and buzzer alert
## Parts
- Arduino Uno
- Servo motor
- HC-SR04 ultrasonic sensor
- Buzzer
- Breadboard and jumper wires

## How it works
The servo sweeps the ultrasonic sensor back and forth. The Arduino measures the distance at each angle and sends the data to the laptop over serial, where the Processing sketch draws the radar screen. The buzzer sounds when an object is close.

## How to run
1. Upload `arduino radar code.ino` to the Arduino.
2. Close the Arduino serial monitor.
3. Run `radar display improved.pde` in Processing.
