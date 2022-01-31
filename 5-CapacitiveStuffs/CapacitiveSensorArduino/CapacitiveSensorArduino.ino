/*
    CapacitiveSensor

*/



#include <CapacitiveSensor.h>

// -- Sensors, set the pins to be the correct ones when using different config
CapacitiveSensor CS1 (4, 2);
CapacitiveSensor CS2 (4, 6);

// -- Serial package settings
char buff[5 * 2 + 4];

void setup() {
  CS1.set_CS_AutocaL_Millis(7000);
  CS2.set_CS_AutocaL_Millis(7000);
  Serial.begin(9600);
  pinMode(9, OUTPUT);

}

inline long processInputVal(long input) {
  return input;
}

void loop()
{
  //Measure 
  int sense_1  {processInputVal(CS1.capacitiveSensor(30))};
  int sense_2  {processInputVal(CS2.capacitiveSensor(30))};
  
  // -- Taken from ArduinoTracker (Previous assignment);
  // Wait for processing to ask for output
  if ( Serial.available() > 0) {
    //Discard everything Processing sent
    while (Serial.available()) {
      Serial.read();
    }
    //Send The data as string using a formatted string to ensure message length
    sprintf(buff, "A%-5d,%-5d", sense_1, sense_2); //Format the message
    Serial.println(buff);
  } // -- END
  
  //tone(9, sense_1 * 2, 10 * (3000 / sense_2)); //Tone testing
  delay(20); //Lower transfer rate
}
