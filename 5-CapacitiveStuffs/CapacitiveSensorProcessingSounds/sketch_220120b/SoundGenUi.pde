
final static float volChSpeed = 0.01/60;
final static float freqChSpeed = 100/60;
final static Wavetable waveTypes[] = {Waves.SINE, Waves.TRIANGLE, Waves.SQUARE, Waves.SAW, null};
final static String waveNames[] = {"SINE", "TRIANGLE", "SQUARE", "SAWT", "Muted"} ;

class SoundGenUI {
  Oscil oscilGen;
  AudioOutput out;
  int waveType = 4;
  boolean changingVolOrFreq;
  boolean select;
  float vol = 0;
  float freq = 20;
  PVector pos;
  char selKey;
  String otherKeys;

  SoundGenUI(AudioOutput ao, PVector pos, char selKey) {
    oscilGen = new Oscil(freq, vol);
    out = ao;
    oscilGen.patch(out);
    this.pos = pos;
    this.selKey = selKey;
    otherKeys = "" ;
    for (int i = 0; i < selKeys.length; i++) {
      otherKeys += selKeys[i] != selKey ? selKeys[i] : "";
    }
  }

  void handleKeyPress(char k) {
    if (select) {
      switch(k) {
      case 'z':
        changingVolOrFreq = !changingVolOrFreq;
        break;
      case 'x':
        changeWave();
        break;
      }
    }

    if (k == selKey) {
      select = !select;
    } else if (otherKeys.contains(""+k)) {
      select = false;
    }
  }
  void changeWave() {
    waveType = (waveType + 1) % 5;

    if (waveType == 4)
      oscilGen.unpatch(out);
    else {
      oscilGen.setWaveform(getWaveType());
      if(waveType == 0){
        oscilGen.patch(out);
      }
    }
  }

  void update(PVector senseInput) {
    if (changingVolOrFreq) {
      changeVol(senseInput.x);
      changeFreq(senseInput.y);
    }
  }
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    noFill();
    stroke(255);
    strokeWeight(3);
    rect(5, 5, 450, 90);

    textAlign(LEFT);
    fill(255);
    textSize(13);
    text(select ? "[X]" : "[ ]", 15, 30);
    text("VOL: " + vol, 40, 30);
    text("FREQ: " + freq, 40, 50);
    text("WAVE: " + waveNames[waveType], 40, 70);
    pushMatrix();
    translate(150,55);
    
    float prevAmpl = 0; 
    for(int i  = 0; i < 280; i ++){
      float ampl = getWaveformVal(((float(i) * freq) / 2000.0) % 1) * 25 * sqrt(vol);
      line(i-1, prevAmpl, i, ampl);
      prevAmpl = ampl;
    }
    
    popMatrix();
    popMatrix();
  }
  float getWaveformVal(float t){
    if(waveType == 4)
      return 0;
    return oscilGen.getWaveform().value(t);
  }
  void changeFreq(float ch ) {
    freq = max(freq + (ch * freqChSpeed),0);
    oscilGen.setFrequency(freq);
  }
  void changeVol(float ch) {
    vol = max(min(vol + (ch * volChSpeed),1),0);
    oscilGen.setAmplitude(vol);
  }
  Wavetable getWaveType() {
    return waveTypes[waveType];
  }
}
