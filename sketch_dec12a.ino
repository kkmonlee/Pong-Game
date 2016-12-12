int byteRead;

void setup() {
  Serial.begin(9600);
  delay(100);

}

void loop() {
  // put your main code here, to run repeatedly:
  while(Serial.available()) {
    byteRead = Serial.read();
    Serial.println(byteRead);
    delay(50);
  }
}
