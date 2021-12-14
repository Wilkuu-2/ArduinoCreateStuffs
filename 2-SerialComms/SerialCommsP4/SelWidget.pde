/*
  SelWidget
  The first menu that opens on startup, facilitates the choice between the server and the client functionality  
*/


class SelWidget extends AppWidget {
  Button serverSelButton, clientSelButton;
  EventPasser eventPasser;
  SelWidget(PVector relPos, PVector size, AppWidget parent){
    super(relPos,size,parent);
    eventPasser = new EventPasser();
    initWidgets();
  }
  void initWidgets(){
    serverSelButton = new Button(new PVector(50,120),new PVector(200,60),this,"Server",getTrigger("startServerGUI"));
    eventPasser.addUpdatable(serverSelButton);
    clientSelButton = new Button(new PVector(300,120),new PVector(200,60),this,"Client", getTrigger("startClientGUI"));
    eventPasser.addUpdatable(clientSelButton);
  }
  EventPasser getEventPasser(){
     return eventPasser;
  }
  


}
