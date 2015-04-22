/* Galileo Email Checker
   by: Jim Lindblom
       SparkFun Electronics
   date: January 7, 2013
   license: Beerware. Please use, reuse, and modify this code.
   If you find it useful, you can buy me a beer when we meet.
   
   This code connects a Galileo to WiFi. Then runs a Python script
   - https://gist.github.com/jimblom/8292444#file-pymailcheck-py -
   that lives on the Galileo's SD card to check how many unread
   emails you have. That number is displayed on an OpenSegment
   Shield - https://www.sparkfun.com/products/11846 - which is
   controlled over SPI.
*/
//////////////////////
// Library Includes //
//////////////////////
#include <SPI.h> // SPI is used to control the OpenSegment Shield
#include <SD.h> // The SD library is used to read a temporary file,
                // where the py script stores an unread email count.
#include <Ethernet.h> // Ethernet library

//////////////////////////
// Ethernet Definitions //
//////////////////////////
byte mac[] = {0x6A, 0x11, 0x1l, 0x30, 0x12, 0x34};

/////////////////////
// Pin Definitions //
/////////////////////
const int SS_PIN = 10; // SPI slave select pin (10 on the shield)
const int STAT_LED = 13; // The Galileo's status LED on pin 13

////////////////////////////////
// Email-Checking Global Vars //
////////////////////////////////
const int emailUpdateRate = 10000; // Update rate in ms (10 s)
long emailLastMillis = 0; // Stores our last email check time
int emailCount = 0; // Stores the last email count

// setup() initializes the OpenSegment, the SD card, and WiFi
// If it exits successfully, the status LED will turn on.
void setup() 
{
  pinMode(STAT_LED, OUTPUT);
  digitalWrite(STAT_LED, LOW);

  Serial.begin(9600); // Serial monitor is used for debug
  initDisplay(); // starts up SPI and resets the OS Shield
  initSDCard();  // Initializes the SD class
  
  if (initEthernet() == 1) // If Ethernet connects, turn on Stat LED
    digitalWrite(STAT_LED, HIGH);
  else
  { // If Ethernet connect fails, print error, inifinite loop
    SPIWriteString("----", 4);
    while (1)
      ;
  }
}

// loop() checks for the unread email count every emailUpdateRate
// milliseconds. If the count has changed, update the display.
void loop() 
{
  // Only check email if emailUpdateRate ms have passed
  if (millis() > emailLastMillis + emailUpdateRate)
  {
    emailLastMillis = millis(); // update emailLastMillis
    
    // Get unread email count, and store into temporary variable
    int tempCount = getEmailCount(); 
    Serial.print("You have ");
    Serial.print(tempCount);
    Serial.println(" unread mail.");
    if (tempCount != emailCount) // If it's a new value, update
    { // Do this to prevent blinking the same #
      emailCount = tempCount; // update emailCount variable
      printEmailCount(emailCount); // print the unread count
    }
  }
  
  // Bit of protection in case millis overruns:
  if (millis() < emailLastMillis)
    emailLastMillis = 0;
}

// printEmailCount(emails) prints the given number to both the
// serial monitor, and the OpenSegment Shield.
void printEmailCount(int emails)
{
  SPIWriteByte('v'); // Clear display
  for (int i=3; i>= 0; i--)
  {
    SPIWriteByte((int) emails / pow(10, i));
    emails = emails - ((int)(emails / pow(10, i)) * pow(10, i));
  }
}

// getEmailCount runs the pyMail.py script, and reads the output.
// It'll return the value printed by the pyMail.py script.
int getEmailCount()
{
  int digits = 0;
  int temp[10];
  int emailCnt = 0;

  // Send a system call to run our python script and route the
  // output of the script to a file.
  system("python /media/realroot/pyMailCheck.py > /media/realroot/emails");

  File emailsFile = SD.open("emails"); // open emails for reading

  // read from emails until we hit the end or a newline
  while ((emailsFile.peek() != '\n') && (emailsFile.available()))
    temp[digits++] = emailsFile.read() - 48; // Convert from ASCII to a number

  emailsFile.close(); // close the emails file
  system("rm /media/realroot/emails"); // remove the emails file

  // Turn the inidividual digits into a single integer:
  for (int i=0; i<digits; i++)
    emailCnt += temp[i] * pow(10, digits - 1 - i);
  
  return emailCnt;
}

// initDisplay() starts SPI, and clears the display to "0000"
void initDisplay()
{
  initSPI(); 
  SPIWriteByte('v');
  SPIWriteString("0000", 4);
}

// initSPI() begins the SPI class, and sets up our SS_PIN output
void initSPI()
{
  pinMode(SS_PIN, OUTPUT);
  digitalWrite(SS_PIN, HIGH);
  
  SPI.begin();
  SPI.setBitOrder(MSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV64);
  SPI.setDataMode(SPI_MODE0);
}

// initSDCard() begins the SD class
void initSDCard()
{
  SD.begin();
}

uint8_t initEthernet()
{
  if (Ethernet.begin(mac) == 0)
    return 0;
  else
    return 1;
}

// SPIWriteString will write an array of chars (str) of length
// len out to SPI. Write order is [0], [1], ..., [len-1].
void SPIWriteString(char * str, uint8_t len)
{
  digitalWrite(SS_PIN, LOW);
  for (int i=0; i<len; i++)
  {
    SPI.transfer(str[i]);
  }
  digitalWrite(SS_PIN, HIGH);
}

// SPIWriteByte will write a single byte out of SPI.
void SPIWriteByte(uint8_t b)
{
  digitalWrite(SS_PIN, LOW);
  SPI.transfer(b);
  digitalWrite(SS_PIN, HIGH);
}
