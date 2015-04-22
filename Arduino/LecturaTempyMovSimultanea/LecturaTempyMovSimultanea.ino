
int pinTemperaturaAnalogo = A0;    // select the input pin for the potentiometer
int pinTemperaturaAnalogo2 = A5;
int pinMovimientoDigital = 2;

int pinLed = 13;      // select the pin for the LED

int sensorValue = 0;
int sensorValue2 = 0;  // variable to store the value coming from the sensor
int contador = 0;

void setup() {
  // declare the ledPin as an OUTPUT:
  pinMode(pinLed, OUTPUT); 
  pinMode(pinMovimientoDigital, INPUT);
   Serial.begin(9600);
   
  for(int i = 0; i < 20; i++){
      Serial.print(".");
      delay(50);  
        digitalWrite(pinLed, HIGH);  
      
      delay(30);
        digitalWrite(pinLed, LOW);  

  }
 
}

void loop() {
  // read the value from the sensor:
  sensorValue = analogRead(pinTemperaturaAnalogo); 
  sensorValue2 = analogRead(pinTemperaturaAnalogo2); 
  int buttonState = digitalRead(pinMovimientoDigital);


  imprimirTemperatura(sensorValue);
  imprimirTemperatura(sensorValue2);
  

  Serial.print("Sensor Movimiento: ");
  Serial.println(buttonState);

  // turn the ledPin on
  digitalWrite(pinLed, HIGH);  
  delay(700);          
  // turn the ledPin off:        
  digitalWrite(pinLed, LOW);   
  delay(300);  
contador++;  
}

float getTemperature(int value)
{
    return (float)(value * 5 * 100 / 1024);
  
}


String convertirTemp(int voltaje)
{
    float f = (float) voltaje;
    float temp = (float)(f * 5 * 100 / 1024);
    String r = "";
    dtostrf(temp, 4, 4, r);
    return r;
}

void imprimirTemperatura(int temp)
{
  
  float degreesC = getTemperature(temp);
  float degreesF = degreesC * (9.0/5.0) + 32.0;
  
  
  Serial.print(contador);
  Serial.print("\t - Valor: ");
  Serial.print(temp);
  Serial.print("  deg C: ");
  Serial.print(degreesC);
  Serial.print("  deg F: ");
  Serial.println(degreesF);
}
