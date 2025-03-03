//www.elegoo.com
//2023.05.05

#include "IRremote.h"

const int receiver = 11; // Signal Pin of IR receiver to Arduino Digital Pin 11
const int buzzerPin = 3;

bool ledState;

/*-----( Declare objects )-----*/
IRrecv irrecv(receiver);     // create instance of 'irrecv'
//vairable uses to store the last decodedRawData
uint32_t last_decodedRawData = 0;
/*-----( Function )-----*/
void translateIR() // takes action based on IR code received
{
  // Check if it is a repeat IR code 
  if (irrecv.decodedIRData.flags)
  {
    //set the current decodedRawData to the last decodedRawData 
    irrecv.decodedIRData.decodedRawData = last_decodedRawData;
    Serial.println("REPEAT!");
  } else
  {
    //output the IR code on the serial monitor
    Serial.print("IR code:0x");
    Serial.println(irrecv.decodedIRData.decodedRawData, HEX);
  }
  //map the IR code to the remote key
  switch (irrecv.decodedIRData.decodedRawData)
  {
    case 0xBA45FF00: powerButton(); break;
    case 0xB847FF00: Serial.println("FUNC/STOP"); break;
    case 0xB946FF00: Serial.println("VOL+"); break;
    case 0xBB44FF00: Serial.println("FAST BACK");    break;
    case 0xBF40FF00: Serial.println("PAUSE");    break;
    case 0xBC43FF00: Serial.println("FAST FORWARD");   break;
    case 0xF807FF00: Serial.println("DOWN");    break;
    case 0xEA15FF00: Serial.println("VOL-");    break;
    case 0xF609FF00: Serial.println("UP");    break;
    case 0xE619FF00: Serial.println("EQ");    break;
    case 0xF20DFF00: Serial.println("ST/REPT");    break;
    case 0xE916FF00: Serial.println("0");    break;
    case 0xF30CFF00: buzz(1);    break;
    case 0xE718FF00: buzz(2);    break;
    case 0xA15EFF00: buzz(3);    break;
    case 0xF708FF00: buzz(4);    break;
    case 0xE31CFF00: buzz(5);    break;
    case 0xA55AFF00: buzz(6);    break;
    case 0xBD42FF00: buzz(7);    break;
    case 0xAD52FF00: buzz(8);    break;
    case 0xB54AFF00: buzz(9);    break;
    default:
      Serial.println(" other button   ");
  }// End Case
  //store the last decodedRawData
  last_decodedRawData = irrecv.decodedIRData.decodedRawData;
  delay(500); // Do not get immediate repeat
} //END translateIR

void setup()   /*----( SETUP: RUNS ONCE )----*/
{
  Serial.begin(9600);
  Serial.println("IR Receiver Button Decode");
  irrecv.enableIRIn(); // Start the receiver

  ledState = false;
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, ledState);

  pinMode(buzzerPin, OUTPUT);

}/*--(end setup )---*/


void loop()   /*----( LOOP: RUNS CONSTANTLY )----*/
{
  if (irrecv.decode()) // have we received an IR signal?
  {
    translateIR();
    irrecv.resume(); // receive the next value

    
  }
}/* --(end main loop )-- */

void powerButton()
{
  ledState = !ledState;
  digitalWrite(LED_BUILTIN, ledState);
}

void buzz(int amount)
{
  if (ledState == false)
  {
    return;
  }
  
  for (int i = 0; i < amount; i++)
  {
    digitalWrite(buzzerPin, HIGH);
    delay(100);

    digitalWrite(buzzerPin, LOW);
    delay(100);
  }
}
