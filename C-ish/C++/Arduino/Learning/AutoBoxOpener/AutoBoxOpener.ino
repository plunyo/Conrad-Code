#include <Servo.h>

Servo myServo;
int trigPin = 9;
int echoPin = 10;
long duration;
int distance;
bool lidIsOpen = false;

void openLid();
void closeLid();

void setup() {
  myServo.attach(3);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;

  if (distance < 20 && !lidIsOpen) {
    openLid();
    delay(2000);
    closeLid();
  }
  delay(500);
}

void openLid() {
  myServo.write(70);
  lidIsOpen = true;
}

void closeLid() {
  myServo.write(-50);
  lidIsOpen = false;
}
