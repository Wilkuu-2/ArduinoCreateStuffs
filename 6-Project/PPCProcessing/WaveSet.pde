/*
 * WaveSet
 *
 * A container for WaveProviders that can output the sum of the waves
 */

import java.time.LocalDateTime;

class WaveSet{
  ArrayList<WaveProv> waves;
  // -- Constructors 
  WaveSet() {
    waves = new ArrayList<WaveProv>();
  }
  WaveSet(WaveProv wav) {
    this();
    addWav(wav);
  }
  
  // -- Adding waves
  void addWav(WaveProv wav){
    waves.add(wav);
  }
  
  // -- Wave summing 
  float getWaveOut(float t, float timeDiv){
    float out = 0;
    for(WaveProv w: waves) 
      out += w.getWaveOut(t,timeDiv);
    return out/getSize();
  }
  
  // -- Getters 
  WaveProv wavAt(int i){
    return waves.get(i);
  } 
  int getSize(){
    return waves.size();
  }
  
  // -- Wrtiting to a file
  void writeToFile(PrintWriter f){
    // -- Header
    f.println(String.format("** - WAVESET -- %s -** ", LocalDateTime.now()));
    for(int i = 0; i < waves.size(); i++){
       WaveProv w = waves.get(i);
       f.println(String.format("WAVE: %d", i));
       f.println(String.format("Volume: %f %%", w.getVol()*100 ));
       f.println(String.format("Freq: %f", w.getFreq()));
       f.println(String.format("Type: %s", w.getWaveName()));
       f.println(String.format("Inverted: %s", w.getIsInverted() ? "YES" : "NO" ));
    
    }
    f.flush();
  }
}
