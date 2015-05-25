import http.requests.*;

// CONSTANTES
String idTempPuntual   = "5540929d762542375f3b8fc2";
String idTempAmbiente  = "552ec624762542382be29da6";
String idMovCuarto     = "55372cbf7625426c5e35903b";
String idMovSala       = "55408ae876254226a67b1398";

int ancho = 600;
int alto = 500;

color amarillo = color(255, 204, 0);
color grisoscuro = color(65);
color grisclaro = color(170);

int tiempoCorto = 400;
int tiempoLargo = 1000;

int tempBaja = 24;  //      x < 24
int tempMedia = 26; // 24 < x < 26
int tempAlta = 28;  // 26 < x < 28
                    // 28 < x

PImage nube, bombillo, bombillote, mundo, persona, temp0, temp1, temp2, temp3;
boolean isNube, isBombillo, isBombillote, isMundo, isPersona;
int rangoTemp;

PFont aller, allerlight, allerdisplay;

// ATRIBUTOS

float temperaturaAmbiente = 0; // la ultima temperatura obtenida
float temperaturaPuntual = 0; // la ultima temperatura obtenida

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
  texto("Cuarto", ancho / 2, 120, 30);
  texto("Puntual", 80, alto - 40, 17);
    
  textAlign(RIGHT);
  texto("Ambiente", ancho - 46, alto - 40, 17);

  textAlign(CENTER);

  fill(fillcolor, 140);

  
  if(millis() - lastCheck > tiempo) {
    thread("actualizarTempPuntual");
    thread("actualizarTempAmbiente");
    thread("actualizarMovimiento");
  }
  
  
  texto(nf(temperaturaPuntual, 0, 1) + "ºC", 80, alto - 18, 20);

  textAlign(RIGHT);
    
  texto(nf(temperaturaAmbiente, 0, 1) + "ºC", ancho - 46, alto - 18, 20);
  
  matachito(mouseX, mouseY);
  imagenes();
}

public void imagenes(){
  
  if(isNube)
    image(nube, ancho / 2 -16, alto - 40);
    
  if(isBombillo)
    image(bombillo, ((ancho / 2) - 134), 8);
 
 image(bombillote, ancho / 2 - 128, alto / 2 - 128);
 if(isBombillote)
   filter(NORMAL);
 else
   filter(GRAY);
   
 
  tint(255, 200); 
  
  if(temperaturaPuntual < tempBaja)
    image(temp0, -38, alto - 107);
  else if(temperaturaPuntual < tempMedia)
    image(temp1, -38, alto - 107);
  else if(temperaturaPuntual < tempAlta)
    image(temp2, -38, alto - 107);
  else
    image(temp3, -38, alto - 107);
  
  
  if(temperaturaAmbiente < tempBaja)
    image(temp0, ancho - 86, alto - 107);
  else if(temperaturaAmbiente < tempMedia)
    image(temp1, ancho - 86, alto - 107);
  else if(temperaturaAmbiente < tempAlta)
    image(temp2, ancho - 86, alto - 107);
  else
    image(temp3, ancho - 86, alto - 107);
}

public void actualizarTempAmbiente(){
  isNube = true;
  isBombillo = false;
  float nueva = getLastFloatValue(idTempAmbiente);
    
    if(temperaturaAmbiente != nueva){
      tiempo = tiempoCorto;
      fillcolor = grisoscuro;
      cambio = true;
    }
    else {
      tiempo = tiempoLargo;
      fillcolor = grisclaro;
      cambio = false;
    }
    
    temperaturaAmbiente = nueva;
    lastCheck = millis();
    
}

public void actualizarTempPuntual(){
  isNube = true;
  isBombillo = false;
  float nueva = getLastFloatValue(idTempPuntual);
    
    if(temperaturaAmbiente != nueva){
      tiempo = tiempoCorto;
      fillcolor = grisoscuro;
      cambio = true;
    }
    else {
      tiempo = tiempoLargo;
      fillcolor = grisclaro;
      cambio = false;
    }
    
    temperaturaPuntual = nueva;
    lastCheck = millis();
    
}

public void actualizarMovimiento() {
  isNube = true;
  int nuevo = getLastIntValue(idMovCuarto);
  
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


