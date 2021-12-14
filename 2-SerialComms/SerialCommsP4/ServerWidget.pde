/*
  Server Widget
  This widget carries the server connect button.
  And eventually the TranscieverWidget
*/

class ServerWidget extends AppWidget {
  Button startServerButton;
  EventPasser eventPasser;
  ServerWidget(PVector relPos, PVector size, AppWidget parent){
    super(relPos,size,parent);
    eventPasser = new EventPasser();
    visible = false;
    initWidgets();
  }
  void initWidgets(){
    startServerButton = new Button(new PVector(240,120),new PVector(260,60),this,"Start Server", getTrigger("startServer"));
    eventPasser.addUpdatable(startServerButton);
  }
  //Returns the eventPasser so to create the transcieverWidget
  EventPasser getEventPasser(){
    return eventPasser;
  }
  


}
