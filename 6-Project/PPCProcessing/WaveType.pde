/*
 * WaveType enum
 * 
 * An enum to store all the necessary information about a waveform
 *
 */
 
 
 enum WaveType{
   SINE(Waves.SINE, "Sine"),
   TRIANGLE(Waves.TRIANGLE, "Triangle"),
   SQUARE(Waves.SQUARE, "Square"),
   SAW(Waves.SAW, "Sawtooth");
   
   String waveName;
   Waveform wave;
   private WaveType(Waveform w, String name){
     waveName = name;
     wave     = w; 
   }
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
