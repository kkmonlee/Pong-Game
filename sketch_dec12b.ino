// Slave Arduino

void setup() {
	// Potentiometers should be connected in analog pins 1 and 2
	pinMode(2, INPUT); 
	pinMode(1, INPUT);
	// Contacting master Arduino on baud 9600
	Serial.begin(9600);
	delay(100);

}

void loop() {
	int reading1 = analogRead(2);
	int reading2 = analogRead(1);

	// Concaternate reading from the 2 potentiometers into one string
	String reading = (String) reading1 + "|" + (String) reading2;

	// Print that string
	Serial.println(reading);
	delay(50);
}
