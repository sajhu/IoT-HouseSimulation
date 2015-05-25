   #include <SPI.h>

   int tempPuntualPin = A0;
   int tempAmbientePin = A2;
   int movimientoPin = 2;

   String temperaturaPuntual = "";
   String temperaturaAmbiente = "";
   int hayMovimiento = false;
   
void setup() {
    // Open serial communications and wait for port to open:
     Serial.begin(9600);
      while (!Serial) { }
      
      pinMode(movimientoPin, INPUT);
}

void loop() {
     int valuePun = analogRead(tempPuntualPin);
     int valueAmb = analogRead(tempAmbientePin);
     int valueMov = digitalRead(movimientoPin);
     String nuevaTemperatura = "";

     
     // MANEJO SENSOR MOVIMIENTO - PIN D2
     if(valueMov != hayMovimiento) {
       hayMovimiento = valueMov;
       Serial.print("Movimiento cambio a ");
       Serial.println(valueMov);
     }
     
     // MANEJO TEMPERATURA PUNTUAL - PIN A0
     nuevaTemperatura = convertirTemp(valuePun);

     if(nuevaTemperatura != temperaturaPuntual){
       temperaturaPuntual = nuevaTemperatura;
       Serial.print("Temperatura  puntual cambió a ");
       Serial.print(temperaturaPuntual);
       Serial.println(" *C");
     }
     
      // MANEJO TEMPERATURA AMBIENTAL - PIN A2
     nuevaTemperatura = convertirTemp(valueAmb);
     
     if(nuevaTemperatura != temperaturaAmbiente){
       temperaturaAmbiente = nuevaTemperatura;
       Serial.print("Temperatura ambiental cambió a ");
       Serial.print(temperaturaAmbiente);
       Serial.println(" *C");
     }
      
      // esperar para la siguiente toma
      delay(100);
}


String convertirTemp(int voltaje)
{
    float f = (float) voltaje;
    float temp = (float)(f * 5 * 100 / 1024);
    String r = String(int(temp)) + "." + String(getDecimal(temp));
    return r;
}

long getDecimal(float val)
{
   int intPart = int(val);
   long decPart = 100*(val-intPart); 
                                   
   if(decPart > 0)return(decPart);           
   else if(decPart < 0) return((-1)*decPart); 
   else if(decPart == 0) return(00);          
}
