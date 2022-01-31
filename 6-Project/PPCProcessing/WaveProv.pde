/*
 *  WaveProv - WaveProvider
 *
 * This is the class handling all the audio:
 *    It plays independently into a given output when output is given and the Provider is enabled
 *    It provides a function output for drawing purposes
 *
 */

final static float volChSpeed  = 0.2/60;
final static float freqChSpeed = 100/60;


class WaveProv {
  Oscil osc;
  AudioOutput out;

  float vol = 0, freq  = 0;
  boolean isInverted = false, isEnabled = true;
  WaveType type = WaveType.SINE;

  WaveProv(AudioOutput ao ) {
    osc = new Oscil(freq, vol, type.getWave());
    out = ao;
    if(out != null){
      osc.patch(out);
    }
  }
  
  // -- Wave Generation
  float getWaveOut(float t, float timeDiv){ //Time div is in pixels/second
    return isEnabled ?  type.getWave().value((t * freq / timeDiv) % 1.0) * (isInverted ? - vol: vol) : 0;
  }

  // -- Getters
  float getVol() {
    return vol;
  }
  float getFreq() {
    return freq;
  }
  String getWaveName() {
    return type.getWaveName();
  }
  boolean getIsInverted() {
    return isInverted;
  }
  boolean getIsEnabled() {
    return isEnabled;
  }


  // -- Setters
  void setVol(float v) {
    vol = v;
    osc.setAmplitude(v * totVol);
  }
  void chVol(float dv) {
    setVol(min(max(vol + dv * volChSpeed, 0), 1));
    println(vol);
  }
  void setFreq(float f ) {
    freq = f;
    osc.setFrequency(f);
  }
  void chFreq(float df) {
    setFreq(min(max(freq + df * freqChSpeed, 0), 2000));
  }
  void chWaveType() {
    type = type.iter();
  }
  void invert() {
    isInverted = !isInverted;
  }
  void toggle() {
    if (isEnabled)
      disable();
    else
      enable();
  }
  void setEnabled(boolean enabled) {
    if (enabled)
      disable();
    else
      enable();
  }
  void enable() {
    isEnabled = true;
    if (out != null) {
      osc.patch(out);
    }
  }
  void disable() {
    isEnabled = false;
    if (out != null) {
      osc.unpatch(out);
    }
  }

}
