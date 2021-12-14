/*
 2-SerialComms - Arduino sketch 
hh
 Just 3 external and one internal LED Blinking together in a array-defined pattern

 Made by Jakub Stachurski
 2021 
*/
#define L_RED 3
#define L_YEL 4
#define L_GRE 5
#define BOUDRT 9600

int ledState[] = {0,0,0};

//Lets us read the messages as both character as numbers
union Message{
    char chars[4];
    int  nums[4]; 
  };

void setup(){ 
  //Enabling pins 3,4,5
  pinMode(L_RED,OUTPUT);
  pinMode(L_YEL,OUTPUT);
  pinMode(L_GRE,OUTPUT);
  //Serial
  Serial.begin(BOUDRT);
}  

//Direct digital pin register write . expanded -> 4-6 lines. NOTE: This way of output is a safe method if you have multiple places you do output on different pins 
void loop() { 
    Message message;
    if(Serial.available() > 3){
       for(int i = 0; i < 4 ; i++){
          message.nums[i] = Serial.read();
        }
        //Toggle the LED
       if(message.chars[0] == 'T'){
          ledState[message.nums[1]] = (ledState[(message.nums[1])%3] + 1) % 2;
          sendACK();
        }
        
      }
    digitalWrite(L_RED,ledState[0]);
    digitalWrite(L_YEL,ledState[1]);
    digitalWrite(L_GRE,ledState[2]);
    }   

void sendACK(){
   Message message;
   message.chars[0] = 'A';
   for(int i = 0; i < 3; i++){
    message.nums[i+1] = ledState[i];
   }
   sendMessage(message);
  }
void sendMessage(Message message){
    for(int i = 0; i < 4; i++){
      Serial.write(message.nums[i]);  
    }
  
  }
