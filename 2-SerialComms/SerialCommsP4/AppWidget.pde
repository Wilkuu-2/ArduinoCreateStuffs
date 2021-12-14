/*
  AppWidget
 A  UI superclass that can fit other objects of itself inside itself
 
 */



//Static stuff, might change it's location. (It would be placed in AppWidget if processing wasn't a language that puts everything in to one file, making all classes inner classes)
static Theme currentTheme; //Default stuff

class AppWidget {
  //Some metadata that is good to have
  boolean selectable = false, selected = false, visible = true;
  
  //Necessary fields
  Theme widgetTheme;
  PVector pos, size;
  AppWidget parent;
  ArrayList<AppWidget> children;

  AppWidget(PVector relPos, PVector size) {
    children = new ArrayList<AppWidget>();
    this.pos  = relPos; 
    this.size = size;
    widgetTheme = currentTheme;
  }
  
  AppWidget(PVector relPos, PVector size, AppWidget parent) {
    this(relPos,size);
    this.parent = parent;
    parent.addChild(this);
  }
  //Adds children that will be drawn under this widget
  void addChild(AppWidget child) {
    children.add(child);
  }
  // -- Getters/Setters 
  PVector getSize() {
    return new PVector(size.x, size.y);
  }
  void  setVis(boolean visible){
    this.visible = visible;
    for(AppWidget c : children){
      c.setVis(visible);
    }
  }
  
  void setTheme(Theme t){
    widgetTheme = t; 
    for(AppWidget c : children){
      c.setTheme(t);
    }
  }
  PVector getAbsPos(){
    if(parent != null){
      return parent.getAbsPos().add(pos);
    } 
    else{
      return(new PVector(pos.x,pos.y));
    }
  }
  // -- Resizing
  void resizeX(float x) {
    size.x = x;
  }
  void resizeY(float y) {
    size.y = y;
  }
  void resize(PVector newSize) {
    resizeX(newSize.x);
    resizeY(newSize.y);
  }
  //-- Moving the widget
  void moveX(float x) {
    pos.x = x;
  }
  void moveY(float y) {
    pos.y = y;
  }
  void move(PVector newPos) {
    moveX(newPos.x);
    moveY(newPos.y);
  }
  // -- Collision check 
  boolean hasPos(PVector target){
    PVector apos = getAbsPos();
    boolean withinX  = (target.x > apos.x && target.x < apos.x + size.x);
    boolean withinY  = (target.y > apos.y && target.y < apos.y + size.y);
    return withinX && withinY;
  }
  // -- Setting up the drawing for the widget and it's children
  void doDraw() {
    if(visible){
      pushMatrix();
      translate(pos.x,pos.y);
      strokeWeight(5);
      drawWidget();
      drawChildren(); //The translation persists, this means that all positions in a child widgets are relative to their parent
      popMatrix();
    }
  }
  
  // -- Actual drawing function
  void drawWidget() {
    widgetTheme.toStroke(TColor.FOREGROUND1);
    widgetTheme.toFill(TColor.BACKGROUND);
    rect(0, 0, size.x, size.y);
  }
  //  -- Iterates over children to let them draw.
  void drawChildren(){
    for(AppWidget child : children){
      child.doDraw();
    }  
  }
}
