/*


*/


class Ring{
  PVector pos;
  float diameter, visibleDiameter;
  float distance; 
  Ring(float dist){
    distance = dist; 
    pos = new PVector(random(width * 0.2, width * 0.8),random(width * 0.2, width * 0.8));
    diameter = random(width * 0.1, width * 0.5);
    visibleDiameter = diameter / sqrt(distance);
  }
  
  void display(){
    strokeWeight(30/sqrt(distance != 0 ? distance : 1));
   //stroke(color(500/sqrt(distance != 0 ? distance : 1))); 
    stroke(255);
    noFill();
    circle(pos.x , pos.y ,(visibleDiameter/2.0));
  }
  boolean update(float forwardSpeed){
    distance += -forwardSpeed;
    return isInOrPastTheCircle();
  }
  boolean isInOrPastTheCircle(){
    return distance <= 0; 
  }
  boolean isWithinCircle(PVector pos2){
    return pos.dist(pos2) < diameter;
  }
}
