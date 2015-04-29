import http.requests.*;

// CONSTANTES
String idTemp = "552ec624762542382be29da6";

int ancho = 600;
int alto = 500;

color amarillo = color(255, 204, 0);
color grisoscuro = color(65);
color grisclaro = color(170);

PImage nube, bombillo, mundo, persona, temp0, temp1, temp2, temp3;
boolean isNube, isBombillo, isMundo, isPersona;
int rangoTemp;

PFont aller, allerlight, allerdisplay;
// ATRIBUTOS
float temperatura = 0; // la ultima temperatura obtenida
int tiempo = 0; // tiempo a esperar para consultar la tempereratura de nuevo
int consultas = 0; // numero de veces que ha sido consultada la temperatura
long lastCheck; // ultima vez que se consultó la temperatura
boolean cambio = false;

color fillcolor = grisclaro;


PImage fai_iconi;
PGraphics fai_icong;
String fai_filename;

void frameAndIcon(String frameText, String iconFilename) {
  if ( fai_filename == null || !fai_filename.equals(iconFilename) ) {
    fai_iconi = loadImage(iconFilename);
    fai_icong = createGraphics(16, 16, JAVA2D);
    fai_filename = iconFilename;
  }
  frame.setTitle( frameText );
  fai_icong.beginDraw();
  fai_icong.image( fai_iconi, 0, 0 );
  fai_icong.endDraw();
  frame.setIconImage(fai_icong.image);
}

public void setup() 
{
  print("Cargando..."); 
 lastCheck = millis(); 
  size(ancho, alto);

  smooth();

  nube = loadImage("cloud.png");
  bombillo = loadImage("bulb.png");
  mundo = loadImage("mundo.png");
  persona = loadImage("persona.png");
  
  temp0 = loadImage("temp0.png");
  temp1 = loadImage("temp1.png");
  temp2 = loadImage("temp2.png");
  temp3 = loadImage("temp3.png");
    
  textSize(64);
  background(#eeeeee);
  fill(0, 140); // Fill black with low opacity
  aller = createFont("aller.ttf", 26);
  

  println("  done. (" + ((float)(millis() - lastCheck)/1000) + "s)");
}

void draw(){
  
  // Initial Resets for each drawing
  background(#eeeeee);
  fill(fillcolor, 140);
  textFont(aller, 32);
  
  
  
  if(millis() - lastCheck > tiempo)
    thread("actualizarTemp");
    
  textAlign(RIGHT);
  texto(nf(temperatura, 0, 1) + "ºC", ancho - 46, alto - 18, 20);
  
  matachito(mouseX, mouseY);
  isBombillo = true;
  imagenes();
}

public void imagenes(){
  
  if(isNube)
    image(nube, 10, alto - 40);
    
  if(isBombillo)
    image(bombillo, 290, 10);
    
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
  float nueva = getLastValue(idTemp);
    
    if(temperatura != nueva){
      tiempo = 500;
      fillcolor = grisoscuro;
      cambio = true;
    }
    else {
      tiempo = 3000;
      fillcolor = grisclaro;
      cambio = false;
    }
    
    temperatura = nueva;
    lastCheck = millis();
    
}


