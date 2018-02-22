#include <Servo.h>

#define portaTranca 6

Servo tranca;

const int buttonPin = 3;
const int redPin = 11;
const int greenPin = 10;
const int bluePin = 9;
int counter = 1;

int buttonState = 0;

enum LockState { LOCKED, UNLOCKED };
LockState state;

void setup() {
  tranca.attach(portaTranca);
  pinMode(buttonPin, INPUT);
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);

  lock();
  updateColor();
  Serial.begin(9600);
}

void loop() {
  
  buttonState = digitalRead(buttonPin);
  
  if (buttonState == LOW) {
    switch(state) {
      case LOCKED:
        unlock();
        break;
      case UNLOCKED:
        lock();
    }
    delay(600);
    updateColor();
  }

  Serial.print(counter, DEC);
}

void unlock() {
    tranca.write(0);
    state = UNLOCKED;
}

void lock() {
    tranca.write(165);
    state = LOCKED;
}

void updateColor() {
    int r, g, b;
    switch(state) {
      case UNLOCKED:
        r = LOW;
        g = HIGH;
        b = LOW;
        break;
      case LOCKED:
        r = HIGH;
        g = LOW;
        b = LOW;
    }
    digitalWrite(redPin, r);
    digitalWrite(greenPin, g);
    digitalWrite(bluePin, b);
}

