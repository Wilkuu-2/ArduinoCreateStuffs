/*
  Transciever Widget
 This widget has the buttons to toggle the leds and handles communiciation as either the server as client
 */

enum TrMode {
  SERVER,
    CLIENT
}

class TranscieverWidget extends AppWidget implements Updatable {
  boolean isActive, waitingForACK = false;
  TrMode mode;
  int[] ledState, indState;
  Serial serial;
  Server server;
  Client thisClient;
  ArrayList<Client> connectedClients;
  Button led1Button, led2Button, led3Button;
  Indicator[] inds;

  TranscieverWidget(PVector relPos, PVector size, AppWidget parent, EventPasser ev, TrMode mode) {
    super(relPos, size, parent);
    this.mode = mode;
    isActive = false;
    ledState = new int[] {0, 0, 0};
    indState = new int[] {2, 2, 2};
    connectedClients = new ArrayList<Client>(1);
    initWidgets(ev);
    ev.addUpdatable(this);
  }
  // -- Creates all the widgets
  void initWidgets(EventPasser ev) {
    Class[] ledToggleParams = {int.class} ;
    led1Button = new Button(new PVector(20, 20), new PVector(120, 50), this, "LED1", getTranscieverTrigger("ledToggle", ledToggleParams, 0));
    led2Button = new Button(new PVector(20, 90), new PVector(120, 50), this, "LED2", getTranscieverTrigger("ledToggle", ledToggleParams, 1));
    led3Button = new Button(new PVector(20, 160), new PVector(120, 50), this, "LED3", getTranscieverTrigger("ledToggle", ledToggleParams, 2));
    inds = new Indicator[] {
      new Indicator(new PVector(180, 20), new PVector(50, 50), this),
      new Indicator(new PVector(180, 90), new PVector(50, 50), this),
      new Indicator(new PVector(180, 160), new PVector(50, 50), this),
    };
    ev.addUpdatables(new Updatable[] {led1Button, led2Button, led3Button});
  }
  //Sets the Server object when using server mode
  void setServer (Server server) {
    this.server = server;
  }
  //Sets the Serial object when using server mode, also marks the widget as active and unlocks the buttons
  void setSerial (Serial serial) {
    this.serial = serial;
    isActive = true;
  }
  //Sets te Client object when using client mode, also marks the widget as active and unlocks the buttons
  void setClient (Client client) {
    this.thisClient = client;
    isActive = true;
  }

  //A helper function to get a method of current object, used for the buttons
  Trigger getTranscieverTrigger(String method, Class[] params, Object... staticArgs) {
    try {
      return new Trigger(TranscieverWidget.class.getMethod(method, params), this, staticArgs);
    }
    catch(Exception E) {
      println("[TRIGGER]: "+method + "|ERROR: " );
      E.printStackTrace();
    }
    return null;
  }

  //Adds the new client to the list
  void connectionEvent(Server someServer, Client someClient) {
    connectedClients.add(someClient);
  }
  //Recieves the messages when they get sent
  void netEvent(Client sender) {
    switch(mode) {
    case SERVER:
      println("server recieve");
      serverRecieve(sender);
      break;
    case CLIENT:
      clientRecieve(sender);
      break;
    }
  }
  //Recieves serial messages when they get sent
  void serEvent(Serial someSerial) {
    if (someSerial == serial) {
      recieveSerial(serial);
    }
  }
  //Synchronises the indicators with what state is saved.
  Response update(EventType type, Object... args) {
    if (type == EventType.FRAMEUP) {
      if (waitingForACK) {
        for (int i = 0; i < 3; i++) {
          inds[i].setState(2); //If the client is waiting for a response, the indicator turns yellow
        }
      } else {
        for (int i = 0; i < 3; i++) {
          inds[i].setState(ledState[i]);
        }
      }
    }
    return Response.SUCCESS; //Returns a response
  }

  //Toggles one of the leds 
  void ledToggle(int num) {
    if (isActive) {
      switch(mode) {
      case SERVER:
        sendToArduino(new int[]{(int)'T', num, 0, 0});
        break;
      case CLIENT:
        sendToServer(new int[]{(int)'T', num, 0, 0});
        break;
      }
      waitingForACK = true; //Waiting for an acknowledgement from the Arduino
    }
  }
  //Updates the state of the led's from what the arduino returns to be the state of the LED's
  void ledStateUpdate(int[] message) {
    for (int i = 1; i < 4; i++) {
      ledState[i-1] = message[i];
    }
    waitingForACK = false;
  }
  
  //Iterates over all clients to send them the message
  void sendToClients(int[] message) {
    print("Sending to clients: ");
    printArray(message);
    for (Client c : connectedClients) {
      println("ACTIVE: "+c.active());
      if (c != null && c.active()) {
        for (int i = 0; i < 4; i++) {
          c.write(message[i]);
        }
      }
    }
  }
  //Sends a message to the server
  void sendToServer(int[] message) {
    if (thisClient != null) {
      println("Sending data");
      for (int i = 0; i < 4; i++) {

        thisClient.write(message[i]);
      }
    }
  }
  //Sending a message to the arduino
  void sendToArduino(int[] message) {
    for (int i = 0; i < 4; i++) {
      serial.write(message[i]);
    }
  }
  //Recieves message from an client of the server and passes it to the arduino
  void serverRecieve(Client client) {
    int[] message = {0, 0, 0, 0};
    if (client != null && client.available() >=3) {
      for (int i  = 0; i < 4; i++) {
        message[i]= client.read();
      }
      sendToArduino(message);
    }
  }
  //Recieves a serial message from the arduino and handles it 
  void recieveSerial(Serial serial) {
    int[] message = {0, 0, 0, 0};
    if (serial.available() > 3) {
      for (int i  = 0; i < 4; i++) {
        message[i]= serial.read();
      }
      //Handling Acknowledgements from the arduino and passing them to clients 
      if ((char) message[0] == 'A') {
        sendToClients(message);
        ledStateUpdate(message);
        println("ACK RECIEVED");
      }
    }
  }
  //Recieving a message from the server
  void clientRecieve(Client client) {
    int[] message = {0, 0, 0, 0};
    if (client.available() > 3) {
      for (int i  = 0; i < 4; i++) {
        message[i]= thisClient.read();
      }
      if (message[0] == (int)'A') {
        println("ACK RECIEVED");
        ledStateUpdate(message);
      }
    }
  }
}
