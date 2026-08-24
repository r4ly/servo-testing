#include <Arduino.h>
#include <Servo.h>

#include "sensors.h"

const int jPinX = A0;
const int jPinY = A1;
const int jPinPress = 2;

void configureAllSensors()
{

    pinMode(jPinX, INPUT);
    pinMode(jPinY, INPUT);
    pinMode(jPinPress, INPUT);
}

int jPosY()
{
    return analogRead(jPinY);
}

int jPosX()
{
    return analogRead(jPinX);
}

bool isButtonPressed()
{
    return digitalRead(jPinPress);
}