// Arduino radar: HC-SR04 on an SG90 servo, buzzer alert, data sent to laptop over USB
#include <Servo.h>

const int TRIG_PIN = 9;
const int ECHO_PIN = 10;
const int SERVO_PIN = 11;
const int BUZZER_PIN = 8;

const int ALERT_DISTANCE_CM = 20;  // buzzer sounds if something is closer than this
const int MIN_ANGLE = 15;
const int MAX_ANGLE = 165;

Servo radarServo;

void setup() {
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  radarServo.attach(SERVO_PIN);
  Serial.begin(9600);
}

int readDistanceCm() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  long duration = pulseIn(ECHO_PIN, HIGH, 30000);  // 30 ms timeout (~5 m)
  if (duration == 0) return 0;                      // nothing detected
  return duration * 0.034 / 2;
}

void scanAt(int angle) {
  radarServo.write(angle);
  delay(40);  // let the servo settle
  int distance = readDistanceCm();

  // Buzzer alert (tone() works for both active and passive buzzers)
  if (distance > 0 && distance < ALERT_DISTANCE_CM) {
    tone(BUZZER_PIN, 2000);
  } else {
    noTone(BUZZER_PIN);
  }

  // Format read by the laptop display: angle,distance.
  Serial.print(angle);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");
}

void loop() {
  for (int angle = MIN_ANGLE; angle <= MAX_ANGLE; angle++) scanAt(angle);
  for (int angle = MAX_ANGLE; angle >= MIN_ANGLE; angle--) scanAt(angle);
}
