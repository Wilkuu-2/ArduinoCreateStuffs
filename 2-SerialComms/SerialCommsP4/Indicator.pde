/*
   Indicator 
   A simple Widget that has different colors depending on the state
*/

class Indicator extends AppWidget{
  int state = 2;
  Indicator(PVector relPos, PVector size, AppWidget parent){
   super(relPos,size,parent);
  }
  @Override
  void drawWidget(){
    widgetTheme.toStroke(TColor.FOREGROUND1);
    widgetTheme.toFill(TColor.IND1,state);
    
    ellipseMode(LEFT);
    ellipse(0,0,size.x,size.y);
  }

  void setState(int state){
     this.state = state;
  }


}
