/*

 
 */


class Game {
  float forwardSpeed = 10.0/60.0;
  static final float sidewaysSpeed = 20.0/60.0;

  PVector playerPos;
  ArrayList<Ring> rings;
  Game() {
    playerPos = new PVector(width / 2, height /2);
    rings = new ArrayList<Ring>(10);
    for (int i = 0; i < 10; i ++)
      rings.add(new Ring(100+100*i));
  }

  void display() {
    for (Ring r : rings) {
      r.display();
    }
    noStroke();
    fill(0, 255, 100);
    rect(playerPos.x - 5, playerPos.y -5, 10, 10);


    String result = "[X]: " + Float.toString(playerPos.x) + " [Y]: "+ Float.toString(playerPos.y);
    text(result, 10, 10);
  }
  int toRemove = -1;
  boolean update(PVector movement) {
    playerPos.x = max(min(( playerPos.x + movement.x + sidewaysSpeed), width ), 0);
    playerPos.y  =max(min((  playerPos.y +movement.y + sidewaysSpeed),height),0);
    boolean rv = true;
    for (Ring r : rings) {
      if (r.update(forwardSpeed)) {
        toRemove = rings.indexOf(r);
        if (! r.isWithinCircle(playerPos)) {
          rv = false; 
        } 
      }
    }
    if (toRemove >= 0) {
      rings.remove(toRemove);
      if(rings.size() > 9)
        assert false;
      rings.add(new Ring(500));
    }
    return true;
  }

  void checkColision() {
  }
}
