public float getLastValue(String id)
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
  return result;
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
  rect(x,y+20,20,60);
  ellipse(x, y-30,60,60);
  ellipse(x- 19, y-30,16,32); 
  ellipse(x + 19, y-30,16,32); 
  line(x - 10,y + 50,x-20,y+60);
  line(x + 10,y + 50,x+20,y+60); 
}
