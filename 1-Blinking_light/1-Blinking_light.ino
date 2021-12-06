/*
 1-Blinking light - Short version

 Just 3 external and one internal LED Blinking together in a array-defined pattern

 Made by Jakub Stachurski
 2021 
*/

//Digital outputs of each diode go here, stored as a series of three uint8_t's in a one dimensional array. NOTE Writing in bintary makes the definition shorter (NOTE: The first bit is pin 7 the last one is pin 0 )
const uint8_t pattern[] = {B00111000,B00111000,B00111000,B00111000,B00111000,B00111000,B00111000,B00111000,B00111000,B00111000,B00001000,
                           B00010000,B00100000,B00000000,B00111000,B00000000,B00111000,B00000000,B00111000,B00000000,B00111000,B00000000,
                           B00111000,B00000000,B00111000,B00000000,B00111000,B00000000,B00111000,B00000000,B00111000,B00000000,B00111000,
                           B00000000,B00111000,B00001000,B00010000,B00100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
                           B00000000,B00000000,B00000000,B00000000,B00001000,B00010000,B00100000}; //Still counts as 1 line :P

//Low level output direction change pins 3,4 and 5 are outputs, expanded -> 2-3 lines (depending on if you count lines with just brackets)
void setup(){ DDRD = DDRD | B00111000;}  

//Direct digital pin register write . expanded -> 4-6 lines. NOTE: This way of output is a safe method if you have multiple places you do output on different pins 
void loop() { for(size_t i = 0; i  < sizeof(pattern);i++){ PORTD= pattern[i]; delay(500);}}   


/*  Total code size: 
  * - Minimal: 3 Lines 
  * - expanded, brackets on the end of the last expression instead of on a new line: 7 lines
  * - Fully expanded, closing brackets on new line: 10 lines
  *
  *
  * - Target: 10 lines
  * Target REACHED iN ALL CIRCUMSTANCES


*/
