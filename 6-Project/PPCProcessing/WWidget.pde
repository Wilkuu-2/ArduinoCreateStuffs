


final color defCol = color(255, 255, 255, 100);
final color selCol = color(30, 100, 255, 100);
final color focCol = color(255, 100, 130, 200);

class WWidget {
  PVector pos, size;
  color fgColor = color(255), bgColor = color(0, 0, 0, 200), borderColor = defCol;
  boolean drawBorder = true;
  boolean drawBG = true;

  WWidget parent = null;
  ArrayList<WWidget> children;

  WWidget(PVector pos, PVector size, WWidget parent) {
    this.pos = pos;
    this.size = size;
    children = new ArrayList<WWidget>();
    if (parent != null) {
      parent.addWChild(this);
    }
  }

  //-- Child - Parent
  void addWChild(WWidget c) {
    children.add(c);
    c.setParent(this);
  }

  void setParent(WWidget p) {
    parent = p;
  }
  // -- Display graphics
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    strokeWeight(15);

    if (drawBG)
      fill(bgColor);
    else
      noFill();

    if (drawBorder)
      stroke(borderColor);
    else
      noStroke();
    rect(0, 0, size.x, size.y);
    _display();

    for (WWidget w : children) {
      w.display();
    }

    popMatrix();
  }

  void _display() {
    // -- Subclass implementing space
  }
  // -- Updating state using the ArduinoReader Class
  void update(ArduinoReader r) {
    _update(r);
    for (WWidget w : children) {
      w.update(r);
    }
  }

  void _update(ArduinoReader r) {
    // -- Subclass implementing space
  }
}
