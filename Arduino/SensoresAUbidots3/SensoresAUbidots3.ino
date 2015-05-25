   #include <SPI.h>
   #include <Ethernet.h>

   // Enter a MAC address for your controller below.
   // Newer Ethernet shields have a MAC address printed on a sticker on the shield
   byte mac[] = {  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };

   int tempPuntualPin = A0;
   int tempAmbientePin = A2;
   int movimientoPin = 2;
   
   int tiempoCorto = 200;
   int tiempoLargo = 500;
   
   // Initialize the Ethernet client library
   // with the IP address and port of the server
   // that you want to connect to (port 80 is default for HTTP):
   EthernetClient client;

   String token = "PKWq1JsD8O7UPdbzfOl0j5VXgBLVgZGVONgSqcPJ7DVAJFDEvIC7FB5MgIrM";

   String idTempAmbiente   = "552ec624762542382be29da6";
   String idTempPuntual    = "5540929d762542375f3b8fc2";
   String idMov            = "55372cbf7625426c5e35903b";

   String temperaturaPuntual = "";
   String temperaturaAmbiente = "";
   int hayMovimiento = false;
   
   int contPuntual = 0;
   int contAmbiental = 0;
   int contMov = 0;
   
   

   void setup() {
    // Open serial communications and wait for port to open:
     Serial.begin(9600);
      while (!Serial) {
       ; // wait for serial port to connect. Needed for Leonardo only
     }
       pinMode(13, OUTPUT); 
       pinMode(movimientoPin, INPUT);

    Serial.println("Attempting to connect to internet...");
     // start the Ethernet connection:
     if (Ethernet.begin(mac) == 0) {
       Serial.println("Failed to configure Ethernet using DHCP");
       // no point in carrying on, so do nothing forevermore:
       for(;;);
     }
     // give the Ethernet shield a second to initialize:
     delay(1000);
         Serial.print("Your IP address: ");
    Serial.println(Ethernet.localIP());
    
       for(int i = 0; i < 20; i++){
      delay(50);
        digitalWrite(13, HIGH);  
      delay(30);
        digitalWrite(13, LOW);  

  }
     Serial.println("connecting...");
   }

   void loop()
   {
     int valuePun = analogRead(tempPuntualPin);
     int valueAmb = analogRead(tempAmbientePin);
     int valueMov = digitalRead(movimientoPin);
     boolean huboCambio = false;
     String nuevaTemperatura = "";
     
     
      // MANEJO SENSOR MOVIMIENTO - PIN D2

     if(valueMov != hayMovimiento) {
       hayMovimiento = valueMov;
       Serial.print(contMov);
       Serial.print(". Actulizando movimiento a ");
       Serial.print(valueMov);
       Serial.println(" ");
       if(hayMovimiento == 1)
         save_value(idMov, "1");
       else
         save_value(idMov, "0");
       digitalWrite(13, LOW);
       huboCambio = true;
       contMov ++;
     }
     
      // MANEJO TEMPERATURA PUNTUAL - PIN A0
     nuevaTemperatura = convertirTemp(valuePun);

     if(nuevaTemperatura != temperaturaPuntual){
       digitalWrite(13, HIGH);

       temperaturaPuntual = nuevaTemperatura;
       Serial.print(contPuntual);
       Serial.print(". Actulizando temperatura  puntual a ");
       Serial.print(temperaturaPuntual);
       Serial.println(" C");
       save_value(idTempPuntual, temperaturaPuntual);
       digitalWrite(13, LOW);
       huboCambio = true;
       contPuntual ++;
     }
 
     // MANEJO TEMPERATURA AMBIENTAL - PIN A2
     nuevaTemperatura = convertirTemp(valueAmb);
     
     if(nuevaTemperatura != temperaturaAmbiente){
       digitalWrite(13, HIGH);

       temperaturaAmbiente = nuevaTemperatura;
       Serial.print(contAmbiental);
       Serial.print(". Actulizando temperatura ambiental a ");
       Serial.print(temperaturaAmbiente);
       Serial.println(" C");
       save_value(idTempAmbiente, temperaturaAmbiente);
       digitalWrite(13, LOW);
       huboCambio = true;
       contAmbiental ++;

     }     
     
     
     if(huboCambio)
       delay(tiempoCorto);
     else
       delay(tiempoLargo);    
   }

   void save_value(String variable, String value)
   {
       // if you get a connection, report back via serial:
       int num=0;
       String var = "{\"value\":";
       var += value;
       var += "}";
       num = var.length();
       if (client.connect("things.ubidots.com", 80)) {
         String post = "POST /api/v1.6/variables/";
         post += variable;
         post += "/values HTTP/1.1\nContent-Type: application/json\nContent-Length: ";
         post += num;
         post += "\nX-Auth-Token: ";
         post += token;
         post += "\nHost: things.ubidots.com\n\n";
         //Serial.println(post + var);
         client.println(post + var);
         client.println();
         client.println("\0");

       }
       else {
         // if you didn't get a connection to the server:
         Serial.println("connection failed");
       }

       if (!client.connected()) {
       Serial.println();
       Serial.println("disconnecting.");

       // do nothing forevermore:
       for(;;);
     }
     while (client.available()) {
       char c = client.read();
      // Serial.print(c);
     }
            client.stop();

   }
   

String convertirTemp(int voltaje)
{
    float f = (float) voltaje;
    float temp = (float)(f * 5 * 100 / 1024);
    String r = String(int(temp))+ "."+String(getDecimal(temp));
    return r;
}

long getDecimal(float val)
{
 int intPart = int(val);
 long decPart = 100*(val-intPart); //I am multiplying by 1000 assuming that the foat values will have a maximum of 3 decimal places
                                   //Change to match the number of decimal places you need
 if(decPart>0)return(decPart);           //return the decimal part of float number if it is available 
 else if(decPart<0)return((-1)*decPart); //if negative, multiply by -1
 else if(decPart==0)return(00);           //return 0 if decimal part of float number is not available
}
