/*
 *  ArduinoReader
 *                   OLD
 *   -- Reads the output from the suntracker --
 *
 *
 *
 *    2022 -- Jakub Stachurski - github.com/Wilkuu-2
 */

import processing.serial.*;

static final int packetSize = 14;
static final int readTimeout  = 20;
final int darkColor  = color(50, 50, 10);
final int lightColor = color(200, 200, 40);


class ArduinoReader {
  float sensor1;
  float sensor2;
  float sensor1MAX = 2000; // Sane initial values
  float sensor2MAX = 2000;

  Serial serial;
  ArduinoReader(PApplet parent) {
    serial = new Serial(parent, Serial.list()[0], 9600);
  }
  //recieves the packets -- Slightly redone part of assignment 3
  //it now uses a fixed length strings instead of raw data to improve debug abilities and simplify the system
  //(Taken from assignment 4 and redone )
  void readSerialData() {
    serial.write('a');
    String input = "";
    long endTime = millis() + readTimeout;
    //Timeout check
    while (millis() < endTime) {
      //Check if a full packet is buffered
      if (serial.available() >= packetSize) {
        //Check if the data is alligned
        if (serial.read() == 'A') {
          //println("[Serial] Packet recieved");

          //Read data into buffer
          input = trim(serial.readStringUntil((int)'\n'));

          //println("[INPUT]" + input);

          

          //println("[0]" + inputs[0]);
          //println("[1]" + inputs[1]);

          //Processing read data into variables
          try{
            String inputs[] = input.split(",");
            sensor1 = parseInt(trim(inputs[0]));
            sensor2 = parseInt(trim(inputs[1]));
          }catch(Exception e){}
          //Everything is done, we can return out of the  method now
          return;
          //Wait for more bytes when there is not enough
        } else {
          try {
            Thread.sleep(5);
          }
          catch (Exception E) {
            assert false;
          }
        }
      }
    }
    //println("[SERIAL] TIMED OUT WITH CONTROLLER");
  }
  void resetMaxValues() {
    sensor1MAX = 0;
    sensor2MAX = 0;
  }
  //Rechecks maximal values;
  void calibrateMaxValues() {
    sensor1MAX = max(sensor1MAX, sensor1);
    sensor2MAX = max(sensor2MAX, sensor2);
    println(" [MAX] 1: " + sensor1MAX+" 2: " + sensor2MAX);
  }
  PVector mapSensorsToVector() {
    if (sensor1MAX > 0 && sensor1MAX > 0){
      print("[MAP] 1: " + sensor1, " 2: " + sensor2);
      println(" [MAX] 1: " + sensor1MAX+" 2: " + sensor2MAX);
      return new PVector(min(max((((sensor1 * 3.0) / sensor1MAX) - 1.0), -1), 1), min(max((((sensor2 * 3.0) / sensor2MAX) - 1), -1), 1));}
    else
      return new PVector(0,0);
    }
  }
