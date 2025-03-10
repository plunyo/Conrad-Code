const int buzzerPin = 5;
const int tiltSwitchPin = 3;


void setup() {
  pinMode(buzzerPin, OUTPUT);
  pinMode(tiltSwitchPin, OUTPUT);
}

void loop() {
  if (digitalRead(tiltSwitchPin) == LOW)
  {
    digitalWrite(buzzerPin, HIGH);
  } else {
    digitalWrite(buzzerPin, LOW);
  }
}
