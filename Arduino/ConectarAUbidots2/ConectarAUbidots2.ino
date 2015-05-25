   #include <SPI.h>
   #include <Ethernet.h>

   byte mac[] = {  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };

   String token = "PKWq1JsD8O7UPdbzfOl0j5VXgBLVgZGVONgSqcPJ7DVAJFDEvIC7FB5MgIrM";

   String idTempAmbiente   = "552ec624762542382be29da6";
   String idTempPuntual    = "5540929d762542375f3b8fc2";
   String idMov            = "55372cbf7625426c5e35903b";

   EthernetClient client;


void setup() {
 Serial.begin(9600);
      while (!Serial) { ; }
       pinMode(13, OUTPUT); 

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
}

void loop() {
  // put your main code here, to run repeatedly: 
  
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
   

