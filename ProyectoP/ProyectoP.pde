import processing.serial.*;
Serial MyPort;

Ellipse elipse1;
Ellipse elipse2;
Ellipse elipse3;
class Ellipse{
  int x =50,y=10,cont=0;
  float diametro;
  
  Ellipse( int _x, int _y, float _diametro){
    x = _x;
    y= _y;
    diametro = _diametro;
  }
  boolean agranda(){
   
    if(cont < 150){
      diametro++;
      ellipse(x,y,diametro,150);
      cont++;
      return false;
    }else{
      ellipse(x,y,diametro,150);
      return true;
    }
  }
}

Square animacion1;
class Square{
  int x;
  int y;
  
  Square( int tempx, int tempy ){
    x = tempx;
    y = tempy;
  }
  
  void mueve(){
    if( x-(25*10) < width ){
      x=x+2;
      fill(43, 245, 2);
      for(int j=1; j<10; j++){
        square(x-(25*j),y,25);  
      }
    }else{
      x = -30;
      do{
        y = 25*int(random(28));
      }while( y == (25*12) || y == (25*13) ); 
    }
  }
    
  
  }



//vairables de archivo
PrintWriter arc;
String[] recordin;
int[] record;
boolean newrecord = false; 


int j=0,m=0;                                                                        //evita repeticiones/contador
int i=0;                                                           //variable para inicializar el juego, al tomar val mayor a 0 evita la repetición

//cuerpo de la serpiente
ArrayList<Integer> x = new ArrayList<Integer>();
ArrayList<Integer> y = new ArrayList<Integer>();
int largo=30, alto=30, bloque=20, dir=0;

//obstaculos
int[] obsx = new int[8];  
int[] obsy = new int[8];

        
int [] dir_x = {0,0,1,-1}, dir_y = {1,-1,0,0};    //direccionales
int comx=20, comy=8;                              //cubos blancos
String joystick;                                  
float dificultad=0;

//tiempo y disparo
boolean disparo;
int timer=0;
int fase;

boolean colision;

//vairable de envio a arduino
String out ;

void setup(){
size(600,700);
frameRate(120);


x.add(5);
y.add(15);


for(int y=0; y<8; y++){
 obsx[y]= (int)random(30);
 obsy[y]= (int)random(30);
}

MyPort = new Serial(this, Serial.list()[1], 9600);
MyPort.bufferUntil('\n');

recordin = loadStrings("Record.txt");                                    //CAGRA DE DATOS DESDE EL TXT

elipse1 = new Ellipse(width/2,270,100);
elipse2 = new Ellipse(width/2,500,200);
elipse3 = new Ellipse(width/2,300,250);
animacion1 = new Square(0, 25*int( random(28) ));

}

void draw(){
  
  String instring = MyPort.readStringUntil('\n');                         //lee datos hasta el salto de linea
  
  if( instring != null ){                                                 //si la entrada es !=null
  joystick = instring;
  }

  if( joystick != null && joystick.contains("T1") || keyPressed && key==' ' || i>0 ){
  i++;
  background(0);
  stroke(255);
  fill(43, 245, 2);
  
  line(0,600,600,600);                                                              //linea inferior
  textSize(20);
  text("Puntuación:", 30, 650);
  text(x.size()-1, 180, 650);
  stroke(0);
  
  text("Tiempo disp.:", 350, 650);
  fill(25);
  rect(350,655,150,30);
  
  fill(43, 245, 2);
  
  if( finjuego() ){                                        // si se sale de la pantalla termina el juego
    background(181, 25, 44);
    textSize(40);
    fill(50);
    text("Puntuación:",160, 150);
    text(x.size()-1, 400, 150);
    
    //println(recordin.length);                                                        //ENVIO al archivo txt
    if( j==0 ){
    Record();
    j++;
    }
    if(newrecord){                                                                     //nuevo record
      textSize(35);

      if(elipse1.agranda()){
        fill(255);
        text("Nuevo record", 185,280);
      }
      if(elipse2.agranda()){
        textSize(50);
        fill(0);
        text("Fin del juego", 155, 520);
      }
    }else{
      if(elipse3.agranda()){
        textSize(50);
        fill(0);
        text("Fin del juego", 155, 320);
      }
    }
    
    
    
    if( keyPressed && key==27 ){                                                          //esc para salir
    exit(); // Stop the program
    }
    
    
  }else{
  timer = timer + 5 ;
  if( timer>5000 ){ timer=5000; }
  
  for( int j=0; j<5; j++){
    if( timer >= (1000)*j ){
      rect( (321+29*(j+1)) ,655,30,30);
    }
  }
  
  colision();                                                            //COLISIONES
  
  for( int i=0; i<x.size() ; i++){
    rect( x.get(i)*bloque, y.get(i)*bloque, bloque, bloque);            //crea los cubos verdes
  }

  direccionales();

  fill(255); 
  rect(comx*bloque, comy*bloque, bloque, bloque);                        //crea los cubos blancos  
  
  if( x.get(0) == comx && y.get(0) == comy){                          // condicion de que se sumó un cubo blanco
  timer = 5000;                                                       // al pasar por el cubo blanco se prepara un diparo
  
  comx = (int)random(30);                                            // genera un valor aleatorio para que aparezca
  comy = (int)random(30);                                            // el proximo cubo blanco    
  
  for( int k=0; k<x.size(); k++){                          
   if( comx == x.get(k) && comy == y.get(k) ){                       //algoritmo que evita que el cubo blanco se genere en los verdes
    comx = (int)random(30); 
    comy = (int)random(30); 
   }
  }
  
  x.add( x.size()+1 );                               // aumenta el tamaño de la serpiente en 1 bloque
  y.add( y.size()+1 );
                            
  dificultad++;
  }
  
  fill(156, 49, 26 );
  
  
  //obsx = (int) random(30);                                 
  //obsy = (int)random(30);                                 
  
  if( dificultad < 5){
  obstaculos(1);
  }  
  if( dificultad >= 5 && dificultad <= 10){
  obstaculos(3);
  }
  if( dificultad >= 10 ){
  obstaculos(6);
  }
  
  
  if(frameCount % 13 == 0){
    x.add(0, x.get(0) + dir_x[dir] );        //hace avanzar la serpiente en x o y
    y.add(0, y.get(0) + dir_y[dir] );
    
    x.remove( x.size()-1 );                  //remueve la cola para que la seriente no sea haga infinita
    y.remove( y.size()-1 );
  }
  
  }
  
 
  }else{
  background(0);
  fill(255);
  
  textSize(50);
  text("♠ Iniciar",width/2-130,height/2);                  //pantalla inicio
  textSize(10);
  text("[espacio o T1]",width/2+100,height/2-10);
  
  animacion1.mueve();
  
  
  }

}
boolean finjuego(){
  if( x.get(0)<0 || x.get(0)>29 || y.get(0)<0 || y.get(0)>29 || colision==true ){    //cond. de fin de juego
  return true;                                                                        //si se sale de los limites o se choca consigo mismo
  }
  return false;
}


void colision(){
    for(int i=2; i<x.size(); i++){
    if( x.get(0)==x.get(i) && y.get(0)==y.get(i) ){                  //detector de colisiones
      colision=true;
    }
    }
    
   }
  
  
void direccionales(){
    if( keyPressed == true ){                      //direccionales de teclado
    
    if( dir==1 && key=='s'){                      //evita volver sobre si mismo y perder accidentalmente
        dir=1;                                    //a cada direccion se le prohibe cambiar a la opuesta de un solo movimiento      
      }else{
    if( dir==0 && key=='w' ){
        dir=0;
      }else{
    if( dir==2 && key=='a' ){
        dir=2;
      }else{
    if( dir==3 && key=='d' ){
        dir=3;
      }else{
      if( key=='w'){dir=1;}
      if( key=='s'){dir=0;}
      if( key=='d'){dir=2;}
      if( key=='a'){dir=3;}
      }
      }
      }
      }
      
    }else{}
      
     if( joystick != null ){                            //direccionales de joystic
     
      if( dir==1 && joystick.contains("Y-") ){            //evita volver sobre si mismo y perder accidentalmente
        dir=1;                                            //a cada direccion se le prohibe cambiar a la opuesta de un solo movimiento      
      }else{
      if( dir==0 && joystick.contains("Y+") ){
        dir=0;
      }else{
      if( dir==2 && joystick.contains("X-") ){
        dir=2;
      }else{
      if( dir==3 && joystick.contains("X+") ){
        dir=3;
      }else{
       if( joystick.contains ("Y+")  ){
         dir=1;
         }
       if( joystick.contains ("Y-")  ){
         dir=0;
         }         
       if( joystick.contains ("X-")  ){
         dir=3;
         }         
       if( joystick.contains ("X+")  ){
         dir=2;
         }            
       }
      }
      }
      }
      }
}

void obstaculos( int m ){

  if( m == 1 ){
  rect(obsx[0]*bloque, obsy[0]*bloque, bloque, bloque);            //dibuja el obstáculo
  }
  if( m == 3 ){
   for(int j=0; j<m; j++){
     rect(obsx[j]*bloque, obsy[j]*bloque, bloque, bloque);
   }
  }
  if( m == 6 ){
   for(int j=0; j<m; j++){
     rect(obsx[j]*bloque, obsy[j]*bloque, bloque, bloque);
   }
  }
  
  for( int k=0; k<m; k++ ){  
  
  if( x.get(0) == obsx[k] && y.get(0) == obsy[k]){                //Se impacta con el obstáculo
  
   if( x.size()>1 && y.size()>1 ){                                //si la serpiente es mayor a una unidad pierde una unidad de largo
   x.remove(x.get(0));
   y.remove(y.get(0));
   }else
  
   obsx[k] = (int)random(30);                                    //genera el proximo obstaculo
   obsy[k] = (int)random(30);
  
  }
  //println(timer);
  
if ( timer == 5000 ){
  //println("disparo listo");
  
  for( int j=0; j<m; j++ ){
  if( joystick != null && joystick.contains("r3") || keyPressed && key == 'e'){
    fill(255,255);
    timer=0;
    
    for(int i=1; i<30; i++){   
  
    if( ( x.get(0)+i*dir_x[dir] ) == obsx[j] && ( y.get(0)+i*dir_y[dir] ) == obsy[j] ){
     i=30;
     obsx[j] = (int)random(30);                                                                   //el obstaculo se destruye
     obsy[j] = (int)random(30);                                                                          
   
     x.add( x.size()+1 );                                                                         // aumenta el tamaño de la serpiente en 1 bloque
     y.add( y.size()+1 );
     dificultad++;
    }
   }
  }
}
}
  
  }
}

void Record(){  
int[] numeros = {0,0,0,0,0,0,0,0,0,0};                  //inicializa un arreglo de enteros
String salida="_";

for(int j=0; j<10; j++){                                 //copia las primeras 10 lineas del txt al arreglo como int
numeros[j] = Integer.parseInt(recordin[j]);
}

numeros = sort(numeros);                                  //ordena el arreglo

for(int i=0; i<10; i++){                                   //verifica si el menor es menor al puntaje obtenido si es así lo remplaza
  if( (x.size()-1) > numeros[i] ){                              
        numeros[i] = (x.size()-1);
        i=10;
        newrecord = true;
      }
}

for(int j=0; j<10; j++){
  recordin[j] = str(numeros[j]);                           //copia el arreglo de int a arreglo de strings
}

saveStrings("Record.txt",recordin);                      //guarda

for(int j=0; j<10; j++){
  
  if( j==0 ){
     salida = salida + recordin[0];
  }else{
  salida = salida + "_" + recordin[j];
  } 
}
  
  printArray(salida);                                    //ENVIA dato al arduino
  MyPort.write(salida);  
  
}
