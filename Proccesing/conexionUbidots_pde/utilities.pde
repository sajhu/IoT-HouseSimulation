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


public float getLastFloatValue(String id)
{
  float result = 0;
  try{
  GetRequest get = new GetRequest("http://things.ubidots.com/api/v1.6/variables/"+ id);
  
  get.setHeader("X-Auth-Token", "rDTig0Elq7mXmKjbj5g2CXFCMDT3LBECwLTnjBIRjla8Wc8Hm581CiWEtahQ");
  get.send(); // program will wait untill the request is completed

  JSONObject response = parseJSONObject(get.getContent());
  JSONObject lastValue = response.getJSONObject("last_value");
  result = lastValue.getFloat("value");
  }catch(Exception e){
    println("Error Ubidots: " + e.getMessage());
  }
  
  isNube = false;
  isBombillo = true;
  return result;
}

public int getLastIntValue(String id)
{
  int result = 0;
  try{
  GetRequest get = new GetRequest("http://things.ubidots.com/api/v1.6/variables/"+ id);
  
  get.setHeader("X-Auth-Token", "rDTig0Elq7mXmKjbj5g2CXFCMDT3LBECwLTnjBIRjla8Wc8Hm581CiWEtahQ");
  get.send(); // program will wait untill the request is completed

  JSONObject response = parseJSONObject(get.getContent());
  JSONObject lastValue = response.getJSONObject("last_value");
  result = lastValue.getInt("value");
  }catch(Exception e){
    println("Error Ubidots: " + e.getMessage());
  }
  
  isNube = false;
  isBombillo = true;
  return result;
}


public void texto(String msg, int x, int y, PFont font, int size){
  textFont(font, size);
  text(msg, x, y);
}

public void texto(String msg, int x, int y, int size){
  textFont(aller, size);
  text(msg, x, y);
}

public void texto(String msg, int x, int y) {
  texto(msg, x, y, 20);
}

public void matachito(int x, int y){
  
  fill(255, 170);
  stroke(200);
  rectMode(CENTER);
  rect(x,y+10,10,30);
  ellipse(x, y-15,30,30);
  ellipse(x- 9, y-15,8,16); 
  ellipse(x + 9, y-15,8,16); 
  line(x - 5,y + 25,x-10,y+30);
  line(x + 5,y + 25,x+10,y+30); 
}
