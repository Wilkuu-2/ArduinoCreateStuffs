/*
 *  ArduinoReader
 *                   OLD
 *   -- Reads the output from the suntracker --
 *
 *  // -- Repurposed + rewritten
 *
 *    2022 -- Jakub Stachurski - github.com/Wilkuu-2
 */

import processing.serial.*;

static final int packetSize = 26;
static final int readTimeout  = 200;
final int darkColor  = color(50, 50, 10);
final int lightColor = color(200, 200, 40);


class ArduinoReader{
  PVector vXY, vFV;
  boolean swTilt = false, swJoy = false, swClick = false;
  Serial serial;
  ArduinoReader(PApplet parent) {
    serial = new Serial(parent, Serial.list()[0], 9600);
    vXY = new PVector(0, 0);
    vFV = new PVector(0, 0);
  }

  
  
  // -- Getters

  PVector getXY() {
    return vXY;
  }
  PVector getFV() {
    return vFV;
  }
  
  boolean getSwTilt() {
    return swTilt ;
  }
  boolean getSwJoy() {
    return swJoy  ;
  }
  boolean getSwClick() {
    return swClick;
  }

  //recieves the packets -- Slightly redone part of assignment 3
  //it now uses a fixed length strings instead of raw data to improve debug abilities and simplify the system
  //(Taken from assignment 4 and redone )
  //(Taken from assignment 5 and redone ) readSensorData -> read()
  void read() {
    serial.write('a');
    String input = "";
    long endTime = millis() + readTimeout;

    while (millis() < endTime) { // Reading loop with timeout
      if (serial.available() >= packetSize && serial.read() == 'A') { //Check if the buffer has an packet-length of data ready and oif it is alligned

        //Read data into a string
        input = trim(serial.readStringUntil((int)'\n'));
        //println("[INPUT]" + input);

        //Processing read data into variables by splitting by delimiter
        try {
          String inputs[] = input.split(",");
          vFV.x= parseFloat(trim(inputs[0])) / 1023.0 * 2.0 -1.0;
          vFV.y = parseFloat(trim(inputs[1])) / 1023.0 * 2.0 -1.0;
          vXY.y = parseFloat(trim(inputs[2])) / 1023.0 * 2.0 -1.0;
          vXY.x = parseFloat(trim(inputs[3])) / 1023.0 * 2.0 -1.0;
        
          swTilt   =trim(inputs[4]).charAt(0) == 'T';
          swJoy   = trim(inputs[5]).charAt(0) == 'T';
          swClick = trim(inputs[6]).charAt(0) == 'T';
        }
        catch(Exception e) {
         // println("[SERIAL] Dropped packet: " + e.toString());
        }
        //Everything is done, we can return out of the  method now
        return;
      } else {  //Wait for more bytes when there is not enough
        try {
          Thread.sleep(5);
        }
        catch (Exception E) {
          assert false;
        }
      }
    }
  }
}
//println("[SERIAL] TIMED OUT WITH CONTROLLER");
