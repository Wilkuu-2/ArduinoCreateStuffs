/*
  SerialCommsP4 [EntryPoint]
 
 
 */
//Imports
import processing.net.*;
import processing.serial.*;
import java.lang.reflect.*;

//Themes
final Theme selectTheme = new Theme(new int[]
  {color(25), color(255), color(100), color(40), color(200), color(0), color(0), color(0)});
final Theme serverTheme = new Theme(new int[]
  {color(5, 5, 75), color(150, 150, 255), color(40, 40, 200), color(15, 15, 130), color(1, 1, 20), color(0), color(255, 0, 0), color(255, 255, 0)});
final Theme clientTheme = new Theme(new int[]
  {color(5, 75, 5), color(150, 255, 150), color(40, 200, 40), color(15, 140, 15), color(1, 20, 1), color(0), color(255, 0, 0), color(255, 255, 0)});

//Globals
PFont mainFont;
EventPasser mainEventPasser;

//Widgets
AppWidget mainWidget;
SelWidget selWidget;
ServerWidget serverWidget;
ClientWidget clientWidget;
TranscieverWidget transWidget;
Label title;

//Text settings
static final int TEXTSIZE = 40;

//Proper starting point
void setup() {
  size(600, 600);
  //Font
  mainFont = createFont("LiberationMono-Bold.ttf", 30);
  textFont(mainFont);
  currentTheme = selectTheme;
  setupWidgets();
}
//Initialize all the important widgets
void setupWidgets() {
  mainWidget = new AppWidget(new PVector(10, 10), new PVector(width-20, height-20));

  //Select widget + setting that as the default
  selWidget = new SelWidget(new PVector(0, 0), new PVector(width-20, height-20), mainWidget);
  mainEventPasser = selWidget.getEventPasser();
  serverWidget = new ServerWidget(new PVector(0, 0), new PVector(width-20, height-20), mainWidget);
  clientWidget = new ClientWidget(new PVector(0, 0), new PVector(width-20, height-20), mainWidget);

  title  = new Label(new PVector(50, 50), new PVector(450, 60), mainWidget, "Remote Led Controller");
}

//Helper method for binding functions to buttons
Trigger getTrigger(String method) {
  try {
    return new Trigger(SerialCommsP4.class.getMethod(method), this);
  }
  catch(Exception E) {
    println("[TRIGGER]: "+method + "|ERROR: " + E.getMessage() );
  }
  return null;
}

//Initializes the Server GUI when the proper button is pressed
void startServerGUI() {
  selWidget.setVis(false); //Make the previous widget invisible
  println("SERVER  GUI STARTING");
  serverWidget.setVis(true); //Make the server gui visible
  mainEventPasser = serverWidget.getEventPasser(); //Change the main EventPasser to pass the updates to the server widget
  startTranscieverWidget(serverWidget, TrMode.SERVER); //Create the transciever widget as the child of server widget
  serverWidget.setTheme(serverTheme); //Theme setting
}

//Keeps the server or client from being initialized more than once;
boolean started = false;

// -- Starting the Serial and the Server objects, while also ending them if anything goes wrong 
void startServer() {
  if (!started) {
    Server s;
    Serial ser;
    try {
      ser = new Serial(this, Serial.list()[0], 9600);
      s = new Server(this, 42069, "localhost");
      if (s.active()) {
        transWidget.setServer(s);
        transWidget.setSerial(ser);
        println("SERVER SETUP SUCESSFULL");
        started = true;
      } else {
        s.stop();
        ser.stop();
        println("SERVER FAILED");
      }
    }
    catch(Exception E) {
      println("SERIAL FAIL, Might be a connection or permission issue");
      println("If it's the ArrayIndexOutOfBoundsException, it's definetely the first");
      E.printStackTrace();
    }
  }
}

//Switches over to the Client GUI
void startClientGUI() {
  println("CLIENT GUI STARTING");
  selWidget.setVis(false);
  clientWidget.setVis(true);
  mainEventPasser = clientWidget.getEventPasser();
  startTranscieverWidget(clientWidget, TrMode.CLIENT);
  clientWidget.setTheme(clientTheme);
}

//Called with a Button to start the client functionality
void startClient() {
  if (!started){
    Client c = new Client(this, clientWidget.getIP(), 42069); //Connect to specified ip
    println(c.active());
    if (c.active()) {
      transWidget.setClient(c);
      started = true;
    } else {
      println("ERROR: Could not make a Client connection, probably a bad/wrong IP. STACKTRACE ABOVE");
    }
  }
}

//This method is a helper for making the TransmitterWidget which carries the connectivity
void startTranscieverWidget(AppWidget parent, TrMode mode) {
  transWidget = new TranscieverWidget(new PVector(15, 300), new PVector(300, 250), parent, mainEventPasser, mode);
}

 
void draw() {
  background(0); 
  mainWidget.doDraw(); // Just pass to the mainWidget
  mainEventPasser.frameUpdate(); //Pass update event 
}
//Passing all necessary events to the event passer
void mouseMoved() {
  mainEventPasser.mouseMove(mouseX, mouseY);
}
void mouseClicked() {
  mainEventPasser.mouseClick(mouseX, mouseY);
}
void mouseDragged() {
  mainEventPasser.mouseDrag(mouseX, mouseY);
}
void keyTyped() {
  mainEventPasser.keyType(key);
}
void keyPressed() {
  mainEventPasser.keyPress(keyCode);
}
void serverEvent(Server someServer, Client someClient){
  transWidget.connectionEvent(someServer,someClient);
}
void clientEvent(Client someClient) {
  transWidget.netEvent(someClient);
}
void serialEvent(Serial someSerial){
  transWidget.serEvent(someSerial);
}
