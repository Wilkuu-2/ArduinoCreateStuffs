/*


*/


class Game{
  static final float forwardSpeed = 100/60;
  static final float sidewaysSpeed = 20/60;
  
  PVector playerPos;
  ArrayList<Ring> rings;
  Game(){
    playerPos = new PVector(width / 2,height /2); 
    rings = new ArrayList<Ring>(10);
    for(int i = 0; i < 10; i ++)
        rings.add(new Ring(100+100*i));
  }
  
  void display(){
    for(Ring r : rings){
       r.display();
    }
    noStroke();
    fill(0,255,100);
    rect(playerPos.x - 5, playerPos.y -5 , 10,10);
    
    
    String result = "[X]: " + Float.toString(playerPos.x) + " [Y]: "+ Float.toString(playerPos.y);
    text(result, 10, 10);
  }
  int toRemove = -1;
  boolean update(PVector movement){
    playerPos.x += movement.x + sidewaysSpeed; 
    playerPos.y += movement.y + sidewaysSpeed; 
    
    for(Ring r : rings){
      if(r.update(forwardSpeed)){
        if(r.isWithinCircle(playerPos)){
          toRemove = rings.indexOf(r);
          break;
        }
        else{
          return false;
        }
      }
    }
    if(toRemove >= 0){
     rings.remove(toRemove);
     rings.add(new Ring(100));
    }
    return true;
  }

  void checkColision(){
  
  }
}
