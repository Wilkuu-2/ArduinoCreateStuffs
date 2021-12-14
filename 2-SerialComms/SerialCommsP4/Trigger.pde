/*
  Trigger
  This class abstracts some of the reflection needed to pass a method as an parameter to an object constructor to make things like buttons work,
  This is how procesisng handles methods like 'void draw()' etc. 
*/

class Trigger {
  Method method;
  Object callObject;
  Object[] staticArgs;
  
  Trigger(Method method, Object callObject){
    this(method,callObject,null);
  }
  Trigger(Method method, Object callObject, Object[] staticArgs){
    this.method = method; 
    this.callObject = callObject;
    this.staticArgs = staticArgs; 
  }
  
  //Invokes the stored method with the static arguments
  void activate(){
    try{
      method.invoke(callObject, staticArgs);
     }
    catch(Exception E){
      print("[TRIGGER][I]: " +  method.getName() + "| ERROR: ");
      E.printStackTrace();
    }
  }
}
