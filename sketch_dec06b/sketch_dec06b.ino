void setup() {
  // put your setup code here, to run once:
  pinMode(2, INPUT);
  pinMode(9, INPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int reading0 = analogRead(2);
  int reading1 = analogRead(9);

  String sendStr = (String) reading0 + "|" + (String) reading1;
  Serial.println(sendStr);
  
  delay(50);

}
