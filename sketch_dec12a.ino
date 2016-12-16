// Master Arduino

int byteRead;

void setup() {
	// Reads from baud 9600
	Serial.begin(9600);
	delay(100);
}

void loop() {
	// While baug 9600 is still open
	while(Serial.available()) {	
		// Read from serial (this will be whatever Slave Arduino is outputting)
		byteRead = Serial.read();
		// Print what Master Arduino saw back out to 9600
		// So Processing can read it
		Serial.println(byteRead);
		// Delay can be adjusted. 50ms was suitable for this laptop
		// Recommended 1-5ms.
		delay(50);
	}
}
