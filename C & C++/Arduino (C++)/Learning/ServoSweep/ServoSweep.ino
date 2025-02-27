#include <Servo.h>

Servo myServo;

const int servoDelay = 1000;
const int servoMax = 180;
const int servoMin = -180;

void setup() {
  myServo.attach(3);
}

void loop() {
  myServo.write(servoMax);
  delay(servoDelay);

  myServo.write(servoMin);
  delay(servoDelay);
}
