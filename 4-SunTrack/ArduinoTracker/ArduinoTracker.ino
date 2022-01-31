/*
    Arduino Suntracker

    An simple inplementation of a suntracker using a voltage divider made for two ldr's.


     2022 - Jakub Stachurski - github.com/Wilkuu-2

*/

#include <Servo.h>

//I don't know if this has any performance implications on AVR hardware, but using const instead of macros is safer in general
const int PIN_LDR = A0;   //Output from the ldr voltage divider
const double speed = 5.0;  // Rotation speed of the servo [deg/ clock cycle * (r1/r2)]
const char start_char = 'A'  ;
Servo servo;

// -- Entry
void setup() {
  Serial.begin(9600);
  pinMode(PIN_LDR, INPUT);
  servo.attach(3);

}

float angle = 0;

// -- Repeat 
void loop() {
  char message[] = "A0000,0000\n"; //message layout
  // Calculate the difference in resistances of the two resistors
  int measure       = (analogRead(PIN_LDR));
  double correction = (measure / 1023.0 - 0.5);
  // Translate that to an angle, while also clamping the angle for servo safety (servo lib might be doing that already '-' )
  angle = max(min(angle + correction * speed, 180), 0) ; //Depending on the wiring you might have to change the `+` into a `-` here

  // Wait for processing to ask for output
  if ( Serial.available() > 0) {
    //Discard everything Processing sent
    while (Serial.available()) {
      Serial.read();
    }
    //Send The data as string using a formatted string to ensure message length 
    sprintf(message, "A%-4d,%-4d\n", measure, round(angle * 10.0)); //https://www.cplusplus.com/reference/cstdio/sprintf/
    Serial.print(message); //If only serial had some sort of printf functionality instead of me having to use sprintf on a buffer

  }


  //Set the angle on the servo
  servo.write(angle);
  delay(3); //We don't need to go too fast
}
