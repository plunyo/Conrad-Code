#include <Servo.h>

Servo myServo;

const int buzzerPin = 5;

const int servoDelay = 1000;
const int servoMax = 180;
const int servoMin = 0;

const int timerSeconds = 10;

int servoPos = 0;

void setup() {
  myServo.attach(3);

  pinMode(buzzerPin, OUTPUT);
}

void loop() {
  for (servoPos = servoMin; servoPos <= servoMax; servoPos += (servoMax / timerSeconds))
  {
    myServo.write(servoPos);
    delay(servoDelay);
  }
  
  buzz(1000);
}

void buzz(int ms)
{
  digitalWrite(buzzerPin, HIGH);
  delay(ms);
  digitalWrite(buzzerPin, LOW);
}
