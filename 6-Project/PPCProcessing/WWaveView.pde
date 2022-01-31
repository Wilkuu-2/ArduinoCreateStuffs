/*
 * WWaveView
 *
 * The widget responsible for drawind the waves into the screen
 *
 */


class WWaveView extends WWidget implements Selectable {
  boolean isSelected = false;
  boolean isFocussed = false;
  boolean editable = true;
  WaveSet waveSet;
  WWaveView(PVector pos, PVector size, WWidget parent, WaveSet wS) {
    super(pos, size, parent);
    waveSet = wS;
  }


  void _display() {
    stroke(fgColor);
    noFill();
    
    pushMatrix();
    translate(0, size.y * 1/2);
    
    float prevAmpl = 0;
    for(int p = 0; p < size.x; p ++){
      float ampl =  waveSet.getWaveOut(float(p), size.x*20) * 0.4 * size.y;
      strokeWeight(1);
      point(p,ampl);
      strokeWeight(0.1);
      line(p-1, prevAmpl, p ,ampl);
    }
    popMatrix();
    
  }

  // -- Focus Related
  void focus() {
    if (editable) {
      isFocussed = true;
      borderColor  = focCol;
    }
  }
  void unFocus() {
    isFocussed = false;
    borderColor = defCol;
  }

  // -- Getters
  boolean isSelected() {
    return isSelected;
  }
  WaveProv getWaveProv(int i) {
    return waveSet.wavAt(i);
  }
  boolean isEditable() {
    return editable;
  }
  // -- Setters
  void setEditable(boolean b) {
    editable = b;
  }

  // -- From the Selectable interface
  void select() {
    isSelected = true; 
    borderColor = selCol;
  }
  void deselect() {
    isSelected  = false; 
    borderColor = isFocussed ? focCol : defCol;
  }
  void onClick() {
    if(!isFocussed) 
      config.setView(this);
    else
      config.setView(null);
  }
}
