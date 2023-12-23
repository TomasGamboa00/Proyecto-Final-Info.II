#include <LiquidCrystal.h>
//contador
String data;
int i=0;
//led
int led = 2;
//touch
int touch1 = 10;

//joystick pins (Analog)
int joyX = 0;
int joyY = 1;
int r3 = 9;

//buzzer
int buzzer = 7;

//variable para leer pins analog 
int joyVal;

 //lcd
//Crear el objeto LCD con los números correspondientes (rs, en, d4, d5, d6, d7)
LiquidCrystal lcd(12, 2, 3, 4, 5, 6);

void setup ()
{
  //led
 pinMode(led, OUTPUT);
  //buzzer
 pinMode(buzzer, OUTPUT);
  //r3
 pinMode(r3,INPUT);
 digitalWrite(r3, HIGH);
 //lcd
 lcd.begin(16, 4);
 //touch
 pinMode(touch1, INPUT);

 Serial.begin(9600);



}

void loop ()
{

  if( digitalRead(r3) == LOW ){
  Serial.println("r3");
  digitalWrite(buzzer,LOW);  
  }else{
  digitalWrite(buzzer,HIGH);    
  }
  delay(30);
    
  if( analogRead(joyX)> 520 && analogRead(joyX)<=1023 ){
  joyVal = analogRead(joyX);
  Serial.print("X-");
  }else{
  if( analogRead(joyX)>= 0 && analogRead(joyX)<500 ){
  joyVal = analogRead(joyX);
  Serial.print("X+");  
  }else
  if( analogRead(joyY)> 520 && analogRead(joyY)<=1023 ){
  joyVal = analogRead(joyY);
  Serial.print("Y-");  
  }else{
  if( analogRead(joyY)>= 0 && analogRead(joyY)<500 ){
  joyVal = analogRead(joyY);
  Serial.print("Y+");  
  }
  }
  }
  Serial.println();
  
  if( digitalRead(touch1) == HIGH ){
  Serial.println("T1"); 
  }




 if (Serial.available() && i==0)                                          //serial recepcion          
  {   
      int pos[11];
      data = Serial.readStringUntil('\n'); 
      //lcd.print(data);
      
      for(int i=0; i<10; i++){
        if(i==0){
           pos[i] = data.indexOf("_",0);
        }else{
          pos[i] = data.indexOf("_",pos[i-1]+1);
        }
        lcd.print(pos[i]);
        lcd.print(".");
        delay(250);
      }
        delay(1000);
        lcd.clear();
      for(int i=0; i<10; i++){
        lcd.print("inicio: ");
        lcd.print(pos[i]);
        lcd.setCursor(0,1);
        lcd.print("fin: ");
        lcd.print(pos[i+1]);
        lcd.setCursor(0,2);

        
        String record = data.substring(pos[i]+1,pos[i+1]);
        lcd.print(record);
        
        delay(1300);
        lcd.clear();
       
        
      }   
      i++;
  }
   
   
  delay(10);
}
