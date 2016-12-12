void setup() {
  pinMode(2, INPUT); 
  pinMode(1, INPUT);
  Serial.begin(9600);
  delay(100);

}

void loop() {
  int reading1 = analogRead(2);
  int reading2 = analogRead(1);

  String reading = (String) reading1 + "|" + (String) reading2;
  
  Serial.println(reading);
  delay(50);

}
