#include <Arduino.h>
#include <Servo.h>

#include "outputs.h"
#include "sensors.h"

void setup(){
    Serial.begin(9600);
    configureAllOutputs();
    configureAllSensors();
}

void loop(){

    /* blinkLED program:
    int blinkCount = random(1, 6);
    Serial.println(blinkCount);
    delay(500);
    blinkBILED(blinkCount);
    delay(2000);
    */

    /* move servo program
    servoActuate(0);
    delay(1500);
    servoActuate(180);
    delay(1500);
    servoActuate(90);
    delay(1500);
    */

    long angle = map(jPosX(), 0, 1023, 0, 180);
    Serial.println(angle);
    servoActuate(angle);
    delay(15);


}
