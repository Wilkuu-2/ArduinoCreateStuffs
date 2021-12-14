/*
  Button
  A Widget that activates a Trigger object when clicked
*/

class Button extends SelectableWidget{
  Trigger onClick; 
  
  Button(PVector relPos, PVector size, AppWidget parent, String text, Trigger onClick){
    super(relPos,size,parent,text);
    this.onClick = onClick;
  }
  // -- Updating
  Response update(EventType evt, Object... args){
     switch(evt){
       case MOUSEMV: //Check for highlighting
         if(!selected && hasPos(new PVector((float) args[0],(float) args[1])) ){
           return Response.ASKSELECT; //Ask to be set as the selected widget
         }
         break;
       case MOUSECL: //Activate the trigger when clicked
         if(hasPos(new PVector((float) args[0],(float) args[1]))){
           if(onClick != null){
               onClick.activate();
           }
         }
       default:
         break; 
     }
     return Response.SUCCESS; //Return
 }
}
