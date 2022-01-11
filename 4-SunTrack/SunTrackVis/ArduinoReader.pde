/*
 *  ArduinoReader
 *
 *  Reads the output from the suntracker
 *
 *    2022 -- Jakub Stachurski - github.com/Wilkuu-2
 */

import processing.serial.*;

static final int packetSize = 11;
static final int readTimeout  = 1000;
static final int arrowLength  = 20;
final int darkColor  = color(50, 50, 10);
final int lightColor = color(200, 200, 40);


class ArduinoReader {
  float angle;
  float  measure;
  Serial serial;
  ArduinoReader(PApplet parent) {
    serial = new Serial(parent, Serial.list()[0], 9600);
  }
  //Draws the indicator that shows the angle of the detector
  void drawAngleIndicator() {
    println("[ANGLE] "+angle+"\n[MEASURE]"+measure);
    strokeWeight(5);
    float indicatorPos = (width-margin*2.0 -4)*((float)angle/180.0) + margin + 2;
    if ((-0.001 < measure && measure < 0.001 )||(indicatorPos < margin + arrowLength || indicatorPos > width - margin - arrowLength) ) {
      line(indicatorPos, height-margin-angleIndicatorSize, indicatorPos, height-margin);
    } else {
      float arrowDir = abs((float)measure)/(float)measure * arrowLength;
      line(indicatorPos, height-margin-angleIndicatorSize, indicatorPos + arrowDir, height-margin-(angleIndicatorSize/2));
      line(indicatorPos + arrowDir, height-margin-(angleIndicatorSize/2), indicatorPos, height-margin);
    }
  }
  //Draws the two yellow rectangles signifying the relative light between the two ldrs 
  void drawSensorOutputs() {
    noStroke();
    fill(lerpColor(darkColor, lightColor, ((measure+1)/2)));
    rect(margin, margin, width/2, height-margin-angleIndicatorSize-10);
    fill(lerpColor(lightColor, darkColor, ((measure+1)/2)));
    rect(width/2, margin, width-margin, height-margin-angleIndicatorSize-10);
  }

  void readSerialData() { //recieves the packets -- Slightly redone part of assignment 3 it now uses a fixed length strings instead of raw data to improve debug abilities and simplify the system
    serial.write('a');
    String input = "";
    long endTime = millis() + readTimeout;
    //Timeout check
    while (millis() < endTime) {
      //Check if a full packet is buffered
      if (serial.available() >= packetSize) {
        //Check if the data is alligned
        if (serial.read() == 'A') {
          println("[Serial] Packet recieved");
          //Read data into buffer
          input = trim(serial.readStringUntil((int)'\n'));
          println("[INPUT]" + input);
          String inputs[] = input.split(",");
          println("[0]" + inputs[0]);
          println("[1]" + inputs[1]);
          //Processing read data into variables
          measure = parseInt(trim(inputs[0])) /1023.0 -0.5 ;
          angle = parseInt(trim(inputs[1])) /10;
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
    println("[SERIAL] TIMED OUT WITH CONTROLLER");
  }
}
