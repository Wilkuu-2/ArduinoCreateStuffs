/*
 *  SuntrackerVis
 *  
 *  A visualization for an arduino suntracker
 *
 *  2022 -- Jakub Stachurski - github.com/Wilkuu-2
 */
 
 
 final int background = color(0); 
 final int foreground = color(255);
 final int margin     = 12;
 final int angleIndicatorSize = 40;
 ArduinoReader reader;
 
 // -- Entry
 void setup(){
   size(800,500);
   reader = new ArduinoReader(this);
 }
 // -- Frame
 void draw(){
   background(0);
   reader.readSerialData();
   reader.drawAngleIndicator();
   reader.drawSensorOutputs();
   drawBorders();
 }
 // -- Draws the borders 
 void drawBorders(){
   strokeWeight(5);
   stroke(foreground);
   float XYMin = margin ;
   float XMax  = width  -  margin;
   float YMax  = height -   margin;
   line(XYMin, XYMin, XMax , XYMin);
   line(XYMin, XYMin, XYMin, YMax);
   line(XYMin, YMax, XMax, YMax);
   line(XMax, XYMin, XMax, YMax);
   line(width/2,XYMin, width/2,YMax-angleIndicatorSize);
   line(XYMin,  height-margin-angleIndicatorSize, XMax, height-margin-angleIndicatorSize);
 }
