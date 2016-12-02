// Valeurs à changer en fonction de ton montage
#define TRIG  10
#define ECHO  11
#define SERVO 12

// Servo lib
#include <Servo.h>
// NewPing lib (à installer)
#include <NewPing.h>

int distance;
// Creation du servo
Servo Servo; 

// Creation du sonar
NewPing sonar(TRIG, ECHO, 500);

void setup() {
  Serial.begin(115200);    // Initialisation de la comm. avec l'ordi
  Servo.attach(SERVO); // Defines on which pin is the servo motor attached
}
void loop() {
  // rotates the servo motor from 0 to 180 degrees
  for(int i=0;i<=180;i++){  
    DataSending(i);
  }
  // Repeats the previous lines from 180 to 0 degrees
  for(int i=180;i>0;i--){  
    DataSending(i);
 }
  
  
}

void DataSending(int j) {
  Servo.write(j);
  delay(20);
  distance = sonar.ping_cm();
  
  Serial.print(j); // Sends the current degree into the Serial Port
  Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  Serial.print(distance); // Sends the distance value into the Serial Port
  Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
}

