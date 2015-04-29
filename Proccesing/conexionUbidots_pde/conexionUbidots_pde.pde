import http.requests.*;

// CONSTANTES
String idTemp = "552ec624762542382be29da6";
String idMovCuarto = "55372cbf7625426c5e35903b";
String idMovSala = "55408ae876254226a67b1398";

int ancho = 500;
int alto = 3000;

color amarillo = color(255, 204, 0);
color grisoscuro = color(65);
color grisclaro = color(170);

int tiempoCorto = 200;
int tiempoLargo = 500;

PImage nube, bombillo, bombillote, mundo, persona, temp0, temp1, temp2, temp3;
boolean isNube, isBombillo, isBombillote, isMundo, isPersona;
int rangoTemp;

PFont aller, allerlight, allerdisplay;

// ATRIBUTOS

float temperatura = 0; // la ultima temperatura obtenida
boolean hayMovimiento = false;
int tiempo = 0; // tiempo a esperar para consultar la tempereratura de nuevo
int consultas = 0; // numero de veces que ha sido consultada la temperatura
long lastCheck; // ultima vez que se consultó la temperatura
boolean cambio = false;

color fillcolor = grisclaro;




public void setup() 
{
  print("Cargando..."); 
 lastCheck = millis(); 
  size(ancho, alto);
  frameAndIcon("Uniandes IoT", "icon.png");

  smooth();

  nube     = loadImage("cloud.png");
  bombillo = loadImage("bulb.png");
  mundo    = loadImage("mundo.png");
  persona  = loadImage("persona.png");
  bombillote = loadImage("bulb.large.png");
  
  temp0 = loadImage("temp0.png");
  temp1 = loadImage("temp1.png");
  temp2 = loadImage("temp2.png");
  temp3 = loadImage("temp3.png");
    
  textSize(64);
  background(#eeeeee);
  fill(0, 140); // Fill black with low opacity
  aller = createFont("aller.ttf", 26);
  allerdisplay = createFont("allerdisplay.ttf", 26);


  println("  done. (" + ((float)(millis() - lastCheck)/1000) + "s)");
}

void draw(){
  
  // Initial Resets for each drawing
  background(#eeeeee);
  textAlign(CENTER);
  fill(grisoscuro);
  texto("Uniandes IoT", ancho / 2, 44, allerdisplay, 30);
  
    fill(fillcolor, 140);

  
  if(millis() - lastCheck > tiempo) {
    thread("actualizarTemp");
    thread("actualizarMovimiento");
  }
    
  textAlign(RIGHT);
  texto(nf(temperatura, 0, 1) + "ºC", ancho - 46, alto - 18, 20);
  
  matachito(mouseX, mouseY);
  imagenes();
}

public void imagenes(){
  
  if(isNube)
    image(nube, 10, alto - 40);
    
  if(isBombillo)
    image(bombillo, ((ancho / 2) - 134), 8);
 
 image(bombillote, ancho / 2 - 128, alto / 2 - 128);
 if(isBombillote)
   filter(NORMAL);
 else
   filter(GRAY);
   
 
  tint(255, 200); 
  if(temperatura < 24)
    image(temp0, ancho - 88, alto - 107);
  else if(temperatura < 25)
    image(temp1, ancho - 88, alto - 107);
  else if(temperatura < 27)
    image(temp2, ancho - 88, alto - 107);
  else
    image(temp3, ancho - 88, alto - 107);
}

public void actualizarTemp(){
  isNube = true;
  isBombillo = false;
  float nueva = getLastFloatValue(idTemp);
    
    if(temperatura != nueva){
      tiempo = tiempoCorto;
      fillcolor = grisoscuro;
      cambio = true;
    }
    else {
      tiempo = tiempoLargo;
      fillcolor = grisclaro;
      cambio = false;
    }
    
    temperatura = nueva;
    lastCheck = millis();
    
}

public void actualizarMovimiento() {
  isNube = true;
  int nuevo = getLastIntValue(idMovSala);
  
  if( nuevo == 1) {
    tiempo = tiempoCorto;
    isBombillote = true;
    hayMovimiento = true;

  }else {
    tiempo = tiempoLargo;
    isBombillote = false;
    hayMovimiento = false;
  }
  
}


