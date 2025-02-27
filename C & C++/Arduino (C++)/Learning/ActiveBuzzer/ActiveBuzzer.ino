const int buzzerPin = 3;
const int buttonPin = 5;


void setup() {
  pinMode(buzzerPin, OUTPUT);
  pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {
  if (digitalRead(buttonPin) == LOW)
  {
    buzz(1000);
  }
}

void buzz(int ms)
{
  for (int i = 0; i < ms / 2; i++)
  {
    digitalWrite(buzzerPin, HIGH);
    delay(1);
    digitalWrite(buzzerPin, LOW);
    delay(1);
  }
}
