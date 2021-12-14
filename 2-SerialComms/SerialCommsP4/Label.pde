/*
  Label 
  A simple widget that displays text
*/


class Label extends AppWidget{
  String text;  
  Label(PVector relPos, PVector size, AppWidget parent, String text) {
    super(relPos,size,parent);
    this.text = text; 
  }
  @Override
  void drawWidget(){
    widgetTheme.toFill(TColor.FOREGROUND1);
    textAlign(CENTER);
    text(text,size.x/2,size.y/2);
  }
}
