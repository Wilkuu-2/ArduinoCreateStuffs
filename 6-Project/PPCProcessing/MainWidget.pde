


class MainWidget extends WWidget {

  Selectable selected = null;
  PVector prevXY = new PVector(0, 0);
  boolean prevClick = false;
  
  MainWidget() {
    super(new PVector(0, 0), new PVector(width, height), null);
  }

  void _update(ArduinoReader r) {
   PVector XY = roundXY(r,0.4);
   PVector dXY = prevXY.sub(XY);
   
   if(dXY.x > 0 && XY.x != 0)
     next();
   if(dXY.x < 0 && XY.x != 0)
     prev();
   if(dXY.y < 0 && XY.y !=0)
     config.chWaveform();
   
    prevXY = XY;
    
    if(r.getSwClick()){
      if(!prevClick && selected != null){
          selected.onClick();
          println("Click");
      }
      prevClick = true;
    }
    else{
      prevClick = false;
    }
  }

  PVector roundXY(ArduinoReader r,float sense) {
    PVector out = new PVector();
    PVector in = r.getXY();
    out.x = (in.x > sense || in.x < -sense) ? in.x/abs(in.x) : 0;
    out.y = (in.y > sense || in.y < -sense) ? in.y/abs(in.y) : 0;
    return out;
  }



  void next() { //Selects next widget
    if (selected != null) {
      selected.deselect();
      Selectable first = null;
      boolean pickedNext  = false;
      boolean pastCurrent = false;

      for (WWidget w : children) {
        if (w instanceof Selectable) {
          if (w == selected) {
            pastCurrent = true; // Went past the current selectable
          } else if (first == null) {
            first = (Selectable) w; // Saving the first found selectable in case of looping around
          } else if (pastCurrent) {
            selected = (Selectable) w;
            pickedNext = true;
            break;  // Found something past the current selectable
          }
        }
      }
      if (!pickedNext && first != null) {  // If nothing found past, pick the first if it exists
        selected = first;
      }
    } else { //When there is no selected, chose the first one
      for (WWidget w : children) {
        if (w instanceof Selectable) {
          selected = (Selectable)(w);
        }
      }
    }
    selected.select();
  }
  void prev() {
    if (selected != null) {
      selected.deselect();
      Selectable last = null;
      Selectable current = selected;
      boolean foundPrev = false;
      boolean pastCurrent = false;

      for (WWidget w : children) {
        if (w instanceof Selectable) {
          if (w == current) { //<>//
            pastCurrent = true; // Went past the current selectable //<>//

          } else if (pastCurrent) { //<>//
            last = (Selectable) w; // Saving the last found selectable in case of looping around //<>//
          } else { //<>//
            selected = (Selectable) w; // Found something before the current selectable //<>//
            foundPrev = true; 
          }
        }
      }
      if (last != null && !foundPrev) {  // If nothing found before, pick the last one if it exists
        selected = last;
      }
    } else { //When there is no selected, choose the first one
      for (WWidget w : children) {
        if (w instanceof Selectable) {
          selected = (Selectable)(w);
        }
      }
    }
    selected.select();
  }
}
