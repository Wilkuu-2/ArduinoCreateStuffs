/*
 * CapacitativeSensorStuff
 *
 *
 *  2022 - Jakub Stachurski -
 */
final int  C_BG = color(30);
final int  C_RING = color(255);

// -- Objects
ArduinoReader reader;
Game game;
// -- Setup
void setup() {
  size(600, 500);
  game = new Game();
  reader = new ArduinoReader(this);
}

// -- per Frame
boolean doesCalibration;
boolean gameActive = true;

void draw() {
  reader.readSerialData();
  
  background(C_BG);
  if (doesCalibration)
    reader.calibrateMaxValues();
  else if (gameActive) {
    gameActive = game.update(reader.mapSensorsToVector());
    game.display();
  } else
    displayGameOver();

  
  
}
// -- Game over screen

void displayGameOver(){
  background(255);
}

  // -- Controlls
  void keyPressed() {
  if (key == 'v' && !doesCalibration) {
    reader.resetMaxValues();
    doesCalibration = true;
  }
}
void keyReleased() {
  if (doesCalibration)
    doesCalibration = false;
}
