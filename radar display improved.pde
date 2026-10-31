// Processing sketch: draws the radar sweep from the Arduino's serial data
// 1. Install Processing from processing.org
// 2. Upload radar.ino to the Arduino first, then CLOSE the Arduino Serial Monitor
// 3. Change PORT_INDEX below if the wrong port is picked, then press Run

import processing.serial.*;

Serial port;
final int PORT_INDEX = 0;       // index in the list printed in the console
final int MAX_CM = 100;         // range shown on the screen
final int ALERT_CM = 20;

int angle = 0;
int distance = 0;
String buffer = "";

// object history so detections fade out instead of vanishing instantly
float[] objX = new float[400];
float[] objY = new float[400];
int[] objAge = new int[400];
int objCount = 0;

void setup() {
  size(1000, 600);
  println(Serial.list());
  port = new Serial(this, Serial.list()[PORT_INDEX], 9600);
  port.bufferUntil('.');
  background(0);
}

void draw() {
  // fade the previous frame for a sweep trail
  noStroke();
  fill(0, 25);
  rect(0, 0, width, height);

  translate(width / 2, height - 40);
  drawGrid();
  drawSweep();
  drawObjects();
  drawText();
}

void serialEvent(Serial p) {
  String data = p.readStringUntil('.');
  if (data == null) return;
  data = data.substring(0, data.length() - 1);
  String[] parts = split(data, ',');
  if (parts.length == 2) {
    angle = int(parts[0]);
    distance = int(parts[1]);
    if (distance > 0 && distance <= MAX_CM) addObject();
  }
}

void addObject() {
  float r = map(distance, 0, MAX_CM, 0, 440);
  float a = radians(angle);
  int i = objCount % objX.length;
  objX[i] = r * cos(a);
  objY[i] = -r * sin(a);
  objAge[i] = 0;
  objCount++;
}

void drawGrid() {
  noFill();
  stroke(0, 160, 0);
  strokeWeight(1);
  for (int i = 1; i <= 4; i++) arc(0, 0, i * 220, i * 220, PI, TWO_PI);
  for (int a = 0; a <= 180; a += 30) {
    line(0, 0, 440 * cos(radians(a)), -440 * sin(radians(a)));
  }
  fill(0, 200, 0);
  textSize(12);
  for (int i = 1; i <= 4; i++) text((MAX_CM / 4 * i) + " cm", i * 110 - 20, -4);
}

void drawSweep() {
  stroke(0, 255, 0);
  strokeWeight(3);
  line(0, 0, 440 * cos(radians(angle)), -440 * sin(radians(angle)));
}

void drawObjects() {
  strokeWeight(10);
  int n = min(objCount, objX.length);
  for (int i = 0; i < n; i++) {
    objAge[i]++;
    int alpha = 255 - objAge[i] * 2;
    if (alpha < 0) continue;
    stroke(255, 40, 40, alpha);
    point(objX[i], objY[i]);
  }
}

void drawText() {
  resetMatrix();
  fill(0);
  noStroke();
  rect(0, height - 36, width, 36);
  fill(0, 255, 0);
  textSize(18);
  String status = (distance > 0 && distance < ALERT_CM) ? "OBJECT CLOSE!" : "Scanning...";
  if (distance == 0) status = "Scanning... (no object in range)";
  text("Angle: " + angle + "°    Distance: " + (distance == 0 ? "--" : distance + " cm") + "    " + status, 20, height - 12);
}
