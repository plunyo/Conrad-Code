const int fanPin = 5;
const int buttonOnPin = 9;
const int buttonOffPin = 8;

void setup()
{
  pinMode(fanPin, OUTPUT);
  pinMode(buttonOnPin, INPUT_PULLUP);
  pinMode(buttonOffPin, INPUT_PULLUP);
}

void loop()
{
  if (digitalRead(buttonOnPin) == LOW)
  {
    digitalWrite(fanPin, HIGH);
  }
  else if (digitalRead(buttonOffPin) == LOW)
  {
    digitalWrite(fanPin, LOW);
  }
}
