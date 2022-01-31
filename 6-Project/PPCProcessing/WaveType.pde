/*
 * WaveType enum
 * 
 * An enum to store all the necessary information about a waveform
 *
 * It's pretty wacky what you can do with enums 
 * 2022 - Jakub Stachurski
 */
 
 
 enum WaveType{
   // -- Enum 
   SINE(Waves.SINE, "Sine"),
   TRIANGLE(Waves.TRIANGLE, "Triangle"),
   SQUARE(Waves.SQUARE, "Square"),
   SAW(Waves.SAW, "Sawtooth");
   
   // -- Fields 
   Waveform wave;   // The type containing the algorithms needed to produce the given wave 
   String waveName; // Name of the wave type
   
   
   private WaveType(Waveform w, String name){
     waveName = name;
     wave     = w; 
   }
   
   // -- Getters 
   String getWaveName(){return waveName;}
   Waveform getWave(){return wave;}
   
    WaveType iter(){
     switch (this){
      case SINE     : return TRIANGLE;
      case TRIANGLE : return SQUARE;
      case SQUARE   : return SAW;
      case SAW      : return SINE;
      default : return SINE;
     }
   }
 
 }
