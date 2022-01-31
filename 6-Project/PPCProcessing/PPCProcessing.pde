
// Minim libs
import ddf.minim.*;
import ddf.minim.ugens.*;

/*
 *  PPC Processing sketch, but i have to write 1000+ lines of code from memory because of a comand line accident
 *
 *
 *  2022 -  Jakub Stachurski
 */


final static float totVol= 0.05;
final float margin = 30;
MainWidget mainWidget;
WWaveConfig config;
ArduinoReader read;
Minim minim;
AudioOutput ao;

// -- Setup



void setup() {
  size(1000, 800);
  read = new ArduinoReader(this);
  minim = new Minim(this);
  ao = minim.getLineOut();

  mainWidget = new MainWidget();


  PVector waveVSize = new PVector(400, 200);
  config = new WWaveConfig(new PVector(margin, margin*3 + waveVSize.y * 2), new PVector(450, 250), mainWidget);

  WaveSet wSetTot = new WaveSet();

  // Add wave View
  for (int i = 0; i <= 4; i ++) {
    WaveProv wPi = new WaveProv(ao);  // -- Wave Providers 
    WaveSet  wSi = new WaveSet(wPi);  // -- Wave sets 
    wSetTot.addWav(wPi);              // -- Adds all Providers into the total set

    PVector pos = new PVector();   // Position of the new widget
    pos.x = margin + ((i +1) %2) * (waveVSize.x + 120);
    pos.y = margin + (i > 2 ? waveVSize.y + margin : 0);
   
    mainWidget.addWChild(new WWaveView(pos, waveVSize, null, wSi)); // Create as child of main widget
  }
  //Create View of the total wave
  WWaveView WVTot =  new WWaveView(new PVector(margin*2 + 500, margin*3 + waveVSize.y * 2 ), new PVector(400, 250), mainWidget, wSetTot);
  WVTot.setEditable(false);
  
  
  println("[Tutorial]: Use left and right on the pad to switch between windows");
  println("[Tutorial]: Click the little button to pick a wave window to edit (the bottom wave is the combination and is not directly changable)");
  println("[Tutorial]: You can turn the controller to invert the wave when it's selected.");
  println("[Tutorial]: Use down on the pad to switch waveform");
  println("[Tutorial]: Use up from the pad to save waveform into a readable format to replicate");
  println("[Hav Fun!]");
}



// -- Draw and update

void draw() {
  background(255);
  read.read();
  mainWidget.display();
  mainWidget.update(read);
}
// -- Controls rounding function
