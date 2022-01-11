/* 
 *  Arduino Suntracker  
 *  
 *  An simple inplementation of a suntracker using a voltage divider made for two ldr's.
 *  
 * 
 *   2022 - Jakub Stachurski - github.com/Wilkuu-2
 *   
 */
 
#include <Servo.h>

//I don't know if this has any performance implications on AVR hardware, but using const instead of macros is safer in general
const int PIN_LDR = A0;   //Output from the ldr voltage divider 
const double speed = 5.0;  // Rotation speed of the servo [deg/ clock cycle * (r1/r2)]
Servo servo;

void setup() {
  //Serial.begin(9600); Debug
  pinMode(PIN_LDR, INPUT); 
  servo.attach(3);

}

double angle = 0;

void loop() {
  //Calculate the difference in resistances of the two resistors 
  double measure = (analogRead(PIN_LDR) /1023.0 - 0.5);
  //Translate that to an angle, while also clamping the angle for servo safety (servo lib might be doing that already '-' )
  angle = min(180.0,max(angle + measure * speed,0)) ; //Depending on the wiring you might have to change the `+` into a `-` here

  // Debug on serial
  //Serial.print(measure);
  //Serial.print(" | ");
  //Serial.println(angle);

  servo.write(angle); //Set the angle on the servo
}
