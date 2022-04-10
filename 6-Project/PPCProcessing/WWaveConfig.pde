/*
 *  WaveConfig Widget 
 * 
 *  Shows info about a selected WaveView and can set the parameters in the WaveProv deep inside the WaveView
 *
 */


class WWaveConfig extends WWidget implements Selectable {
  boolean isSelected = false;
  boolean prevTilt = false;

  WWaveView view = null;

  WWaveConfig(PVector pos, PVector size, WWidget parent) {
    super(pos, size, parent);
    borderColor = focCol;
  }

  @Override
    void _display() {
    drawVolumeBar();
    drawTextBar("FREQ",(view != null)? Float.toString(view.getWaveProv(0).getFreq()) :"" , margin +70, margin);
    drawTextBar("WAVEF",(view != null)? view.getWaveProv(0).getWaveName() :"" , margin +70, margin + 70);
    drawTextBar("INV",(view != null)? Boolean.toString(view.getWaveProv(0).getIsInverted()) :"" , margin +70, margin + 140);
  }

  void drawTextBar(String front, String back, float x, float y) {
    pushMatrix();
    
    translate(x,y);
    noStroke();
    fill(fgColor);
    rect(0,0,100, 50);
    
    textSize(30);
    textAlign(LEFT);
    fill(bgColor);
    text(front, 10, 35);
    
    textSize(30);
    textAlign(LEFT);
    fill(fgColor);
    text(back, 110, 35);
    
    noFill();
    stroke(borderColor);
    strokeWeight(10);

    rect(0,0,300,50);
    
    popMatrix();
    
  }


  void drawVolumeBar() {
    textAlign(CENTER);

    noStroke();
    fill(fgColor);
    rect(margin, margin, 50, 30);

    textSize(30);
    fill(bgColor);
    text("V", margin + 25, margin+28);

    if (view != null) {
      WaveProv prov = view.getWaveProv(0);
      pushMatrix();
      translate(margin, margin+(1-prov.getVol()) * 160 + 30);
      noStroke();
      fill(selCol);
      rect(0, 0, 50, 160 * prov.getVol());
      popMatrix();
      }

    noFill();
    stroke(borderColor);
    strokeWeight(10);
    rect(margin, margin, 50, 190);
  }


  // -- Updating the state of the views
  @Override
    void _update(ArduinoReader r) {
    if (view != null && view.isSelected) {
      PVector FV = r.getFV();
      WaveProv prov = view.getWaveProv(0);
      prov.chFreq(FV.x);
      prov.chVol(FV.y);
      // -- Invertion
      if (!r.getSwTilt()) {
        if (!prevTilt) {
          prov.invert();
        }
        prevTilt = true;
      } else {
        prevTilt = false;
      }
    }
  }

  // -- Set the view managed by the configuration widget
  void setView(WWaveView v) {
    if (view != null)
      view.unFocus();
    if (v != null && v.isEditable()) {
      view = v;
      view.focus();
    } else {
      view = null;
    }
  }
  // Uses enchanced controls from the main widget to switch waveform 
 void chWaveform(){
   if(view != null){
     view.getWaveProv(0).chWaveType();
   }
 }
  // -- From the Selectable Interface
  void select() {
    isSelected = true;
    borderColor = selCol;
  }
  void deselect() {
    isSelected = false;
    borderColor = focCol;
  }
  void onClick() {
    if (view != null) {
      view.getWaveProv(0).toggle();
    }
  }
}
