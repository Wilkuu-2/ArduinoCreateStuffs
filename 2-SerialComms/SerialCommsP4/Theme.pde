/*
  Theme (and the TColor enum)
*/

// This enum shows all the colors that can be taken from a theme 
enum TColor {
    BACKGROUND(0),
    FOREGROUND1(1),
    FOREGROUND2(2),
    BUTTON(3),
    BUTTONHIGHLIGHT(4),
    IND1(5),
    IND2(6),
    IND3(7);

  private int value;
  public static final int len = TColor.values().length;

  private TColor(int val) {
    value = val;
  }
  int getValue() {
    return value;
  }
}

//The theme class that stores all the colors of a theme
class Theme {
  int[] colors;
  Theme(int[] colors) {
    this.colors = colors;
  }
  // --Sets stroke or fill to the theme color
  void toStroke(TColor col) {
    stroke(colors[col.getValue()]);
  }
  void toFill(TColor col) {
    fill(colors[col.getValue()]);
  }
  // --The same as above but with an offset
  void toStroke(TColor col, int offset) {
    stroke(colors[col.getValue()+offset]);
  }
  void toFill(TColor col, int offset) {
    fill(colors[col.getValue()+offset]);
  }
}
