


abstract class SelectableWidget extends AppWidget implements Selectable {
  String text;

  SelectableWidget(PVector relPos, PVector size, AppWidget parent, String text) {
    super(relPos, size, parent);
    this.text = text;
  }
  //Sets the widget to change depending on selection
  @Override
    void drawWidget() {
    if (selected) {
      widgetTheme.toStroke(TColor.FOREGROUND2);
      widgetTheme.toFill(TColor.BUTTONHIGHLIGHT);
    } else {
      widgetTheme.toStroke(TColor.FOREGROUND1);
      widgetTheme.toFill(TColor.BUTTON);
    }
    rect(0, 0, size.x, size.y);
    drawText();
   }
   
  void drawText() {
    if (selected) {
      widgetTheme.toFill(TColor.FOREGROUND2);
    } else {
      widgetTheme.toFill(TColor.FOREGROUND1);
    }
    textAlign(CENTER);
    text(text, size.x/2, size.y/2 + TEXTSIZE/4);
  }
  void select() {
    selected = true;
  }
  void deSelect() {
    selected = false;
  }
}
