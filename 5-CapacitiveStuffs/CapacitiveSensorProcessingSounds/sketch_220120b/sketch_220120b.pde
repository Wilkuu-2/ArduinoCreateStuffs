import ddf.minim.*;
import ddf.minim.ugens.*;

/*
 * CapacitativeSensorStuff
 *
 *
 *  2022 - Jakub Stachurski -
 */
final char[] selKeys = {'a','s','d'};
final int  C_BG = color(30);
final int  C_RING = color(255);

// -- Objects
Minim minim;
AudioOutput ao;
ArduinoReader reader;
SoundGenUI gens[];
boolean doesCalibration;

// -- Setup

void setup() {
  size(600, 500);
  reader = new ArduinoReader(this);
  doesCalibration = true;
  minim = new Minim(this);
  ao = minim.getLineOut(Minim.MONO);
  gens = new SoundGenUI[3];
  for(int i = 0; i < 3; i++)
      gens[i] = new SoundGenUI(ao,new PVector(40,40+120*i),selKeys[i]);
}

// -- per Frame
void draw() {
  reader.readSerialData();
  background(C_BG);

  if (doesCalibration)
    calDraw();
  else {
    for(SoundGenUI s : gens){
      s.display();
    }
    for(SoundGenUI s : gens){
      s.update(reader.mapSensorsToVector());
    }
    outputDraw();
  }
}

// -- Game over screen
void calDraw() {
  reader.calibrateMaxValues();
  background(255);
  fill(0);
  textAlign(CENTER);
  text("[CALIBRATION MODE]\nHold you hand close to the plates.\nAfter doing that press 'v' to continue", width/2, height/2);
}

void outputDraw(){
    pushMatrix();
    translate(50,450);
    float OUTprevAmpl = 0;
    for(int i  = 0; i <  ao.bufferSize() - 1  && i < 450; i ++){
      float ampl = ao.right.get(i) * 100;
      line(i-1, OUTprevAmpl, i, ampl);
      OUTprevAmpl = ampl;
    }
    
    popMatrix();
}

// -- Controls
/*
 * v -> (TOGGLE) Calibration( hold the hand close to the plates )
 * a -> (TOGGLE) Sound 1 config select
 * s -> (TOGGLE) Sound 2 config select 
 * d -> (TOGGLE) Sound 3 config select 
 * z -> (TOGGLE) Change volume and pitch of selected sound
 * y -> (PRESS) Change waveform of selected sound
 */
void keyPressed() {
  if (key == 'v') {
    if (!doesCalibration) {
      reader.resetMaxValues();
      doesCalibration = true;
    } else{
      doesCalibration = false; 
    }
  }
  for(SoundGenUI s : gens ){
    s.handleKeyPress(key);
  }
}
void keyReleased() {
}
