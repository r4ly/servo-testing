#include <Arduino.h>
#include <Servo.h>

#include "outputs.h"

Servo servo;

void configureAllOutputs() // output initialization
{
    pinMode(LED_BUILTIN, OUTPUT);
    servo.attach(9);
}

void blinkBILED(int times) // blink the built in led
{
    for (int count = 1; count <= times; count++)
    {
        digitalWrite(LED_BUILTIN, HIGH);
        delay(500);
        digitalWrite(LED_BUILTIN, LOW);
        delay(500);
    }
}

void servoActuate(int angleDeg) // rotates the servo
{
    servo.write(angleDeg);
}