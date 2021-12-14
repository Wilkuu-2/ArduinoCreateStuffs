/*
  EventPasser (and some interfaces and enums)
 This class allows to avoid updating every widget at every event by updating only attached widgets
 */
 
 
//The Interface for classes that needs updating 
interface Updatable {
  Response  update(EventType eventT, Object... args);
}
//The interface for classes that can be selected, like buttons 
interface Selectable extends Updatable {
  void select();
  void deSelect();
}

//All types of events that can be sent
enum EventType {
    FRAMEUP,
    MOUSEMV,
    MOUSECL,
    MOUSEDR,
    KEYTYPE,
    KEYPRES
}
//All the responses that can be recieved from widget
enum Response {
  ASKSELECT,
    SUCCESS,
    FAIL,
}


class EventPasser {
  Selectable selected;
  ArrayList<Updatable> updatables;
  
  EventPasser() {
    updatables = new ArrayList<Updatable>();
  }
  //Adding and removing updatables
  void addUpdatable(Updatable u) {
    updatables.add(u);
  }
  //Adding updatables in a batch
  void addUpdatables(Updatable[] us) {
    for(Updatable u : us){
      updatables.add(u);
    }
  }

  //--Handles
  void mouseMove(float mouse_x, float mouse_y) {
    sendUpdate(EventType.MOUSEMV, mouse_x, mouse_y);
  }
  void mouseClick(float mouse_x, float mouse_y) {
    sendUpdate(EventType.MOUSECL, mouse_x, mouse_y);
  }
  void mouseDrag(float mouse_x, float mouse_y) {
    sendUpdate(EventType.MOUSEDR, mouse_x, mouse_y);
  }
  void keyType(char letter){
    sendUpdate(EventType.KEYTYPE, letter);
  }
  void keyPress(int kCode){
    sendUpdate(EventType.KEYPRES, kCode);
  }
  void frameUpdate(){
    sendUpdate(EventType.FRAMEUP);
  }

  //--Actual update sending
  void sendUpdate(EventType eventT, Object... args) {
    for (Updatable upd : updatables) {
      switch(upd.update(eventT, args)) {
      case ASKSELECT:
        switchSelected(upd);
        break;
      case FAIL:
        assert(false);
      case SUCCESS:
        break;
      }
    }
  }
  //Switching what updatable is selected 
  void switchSelected(Updatable upd) {
    if (selected != null) {
      selected.deSelect();
    }
    selected = ((Selectable) upd);
    selected.select();
  }

  //
}
