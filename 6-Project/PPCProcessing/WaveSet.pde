/*
 * WaveSet
 *
 * A container for WaveProviders that can output the sum of the waves
 */



class WaveSet{
  ArrayList<WaveProv> waves;
  WaveSet() {
    waves = new ArrayList<WaveProv>();
  }
  WaveSet(WaveProv wav) {
    this();
    addWav(wav);
  }
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
}
