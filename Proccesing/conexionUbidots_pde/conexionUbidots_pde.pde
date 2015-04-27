import http.requests.*;

// CONSTANTES
String idTemp = "552ec624762542382be29da6";

color amarillo = color(255, 204, 0);
color grisoscuro = color(65);
color grisclaro = color(170);

// ATRIBUTOS
float temperatura = 0; // la ultima temperatura obtenida
int tiempo = 0; // tiempo a esperar para consultar la tempereratura de nuevo
int consultas = 0; // numero de veces que ha sido consultada la temperatura
long lastCheck; // ultima vez que se consultó la temperatura
boolean cambio = false;

color fillcolor = grisclaro;


public void setup() 
{
  print("Cargando..."); 
 lastCheck = millis(); 
  size(400,400);
  smooth();

  
    
  textSize(64);
  background(#eeeeee);
  fill(0, 140); // Fill black with low opacity
  PFont zigBlack = createFont("Ziggurat-Black", 32);
  textFont(zigBlack);

  println("  done. (" + ((float)(millis() - lastCheck)/1000) + "s)");
}

void draw(){
  
  background(#eeeeee);
  fill(fillcolor, 140);
  
  if(millis() - lastCheck > tiempo)
    thread("actualizarTemp");
  
  text(nf(temperatura, 0, 1) + "ºC", 280, 380);
  
  matachito(mouseX, mouseY);
}

public void actualizarTemp(){
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

public float getLastValue(String id)
{
    GetRequest get = new GetRequest("http://things.ubidots.com/api/v1.6/variables/"+ id);
  
  get.setHeader("X-Auth-Token", "rDTig0Elq7mXmKjbj5g2CXFCMDT3LBECwLTnjBIRjla8Wc8Hm581CiWEtahQ");
  get.send(); // program will wait untill the request is completed

  JSONObject response = parseJSONObject(get.getContent());
  JSONObject lastValue = response.getJSONObject("last_value");
  float result = lastValue.getFloat("value");
  return result;
}

public void matachito(int x, int y){
  
  fill(255, 170);
  stroke(200);
  rectMode(CENTER);
  rect(x,y+20,20,60);
  ellipse(x, y-30,60,60);
  ellipse(x- 19, y-30,16,32); 
  ellipse(x + 19, y-30,16,32); 
  line(x - 10,y + 50,x-20,y+60);
  line(x + 10,y + 50,x+20,y+60); 
}
