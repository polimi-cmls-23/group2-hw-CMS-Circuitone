int switcher = 3;                 // Connect Tilt sensor to Pin3
int isLow = 0;
int softness = 0;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(switcher, INPUT);
  Serial.begin(9600);
}

void loop()
{
  int potValue = analogRead(A0);
  if (abs(potValue - softness) > 5) {
    softness = potValue;
    int mapped_softness = map(softness, 0, 1023, 2, 255);
    Serial.write(mapped_softness);
  }
  if(digitalRead(switcher)==HIGH && isLow==0) //Read sensor value
    {
      digitalWrite(LED_BUILTIN, HIGH);   // Turn on LED when the sensor is tilted
      Serial.write(1);
      isLow = 1;
    }
  else
    {
      if(digitalRead(switcher)==LOW && isLow==1)
      {
        digitalWrite(LED_BUILTIN, LOW);    // Turn off LED when the sensor is not triggered
        Serial.write(0);
        isLow = 0;
      }
    }
  delay(50);
}