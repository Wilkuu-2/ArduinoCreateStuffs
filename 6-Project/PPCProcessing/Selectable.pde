/*
 *  Selectable interface
 *  
 * Implementing classes will be able to be selected and clicked on 
 *
 * 2022 - Jakub Stachurski 
 */
 
 
 interface Selectable{
   void select();   // Called when getting selected 
   void deselect(); // Called when something else is getting selected and the this object is no longer selected 
   void onClick();  // Called when selected and the user presses the push button
 }
