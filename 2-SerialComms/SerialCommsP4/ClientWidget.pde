
/*
  Client Widget
  Carries all the buttons and input that is client-only
  And eventually the TranscieverWidget
*/

class ClientWidget extends AppWidget {
  Button startClientButton;
  TextArea IPField;
  EventPasser eventPasser;
  
  ClientWidget(PVector relPos, PVector size, AppWidget parent){
    super(relPos,size,parent);
    eventPasser = new EventPasser();
    visible = false;
    initWidgets();
  }
  void initWidgets(){
    startClientButton = new Button(new PVector(240,120),new PVector(260,60),this,"Start Client", getTrigger("startClient"));
    IPField = new TextArea(new PVector(25,190),new PVector(500,60),this);
    eventPasser.addUpdatables(new Updatable[] {startClientButton, IPField});
  }
  
  //Read the IP from the input field
  String getIP(){
    return IPField.getTextData();
  } 
  //Returns the eventPasser so to create the transcieverWidget
  EventPasser getEventPasser(){
    return eventPasser;
  }
  
 
}
