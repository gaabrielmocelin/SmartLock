#include <Servo.h>

#define portaTranca 6

Servo tranca;

const int button1Pin = 5;
const int button2Pin = 4;
const int button3Pin = 3;

const int redPin = 11;
const int greenPin = 10;
const int bluePin = 9;
int counter = 1;

int buttonState = 0;

unsigned long int lockUpdateTimestamp;
boolean updatingLock = false;

enum LockState { LOCKED, UNLOCKED };
LockState state;

void setup() {
  tranca.attach(portaTranca);
  pinMode(button1Pin, INPUT);
  pinMode(button2Pin, INPUT);
  pinMode(button3Pin, INPUT);
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);

  lock();
  updateLockStatusColor();
  Serial.begin(115200);
}

int nextDelay = 0;
uint8_t byteRead = 0;

int once = 0;

void loop() {
  if (updatingLock) {
      if (millis() - lockUpdateTimestamp >= 600) {
          updatingLock = false;
          updateLockStatusColor();  
      }
  } else {
    checkButton();
  }
  
  if (Serial.available() > 0) {
    byteRead = Serial.read();
    Serial.println(byteRead);

    if (byteRead == 'U') {
      unlock();
    } else if (byteRead == 'L') {
      lock();
    }
  }
}

void checkButton() {  
  buttonState = digitalRead(button1Pin);
  int buttonState2 = digitalRead(button2Pin);
  int buttonState3 = digitalRead(button3Pin);
  
  if (buttonState == LOW || buttonState2 == LOW || buttonState3 == LOW ) {
    switch(state) {
      case LOCKED:
        unlock();
        break;
      case UNLOCKED:
        lock();
    }
    lockUpdateTimestamp = millis();
    updatingLock = true;
  }
}

void unlock() {
    tranca.write(0);
    state = UNLOCKED;
}

void lock() {
    tranca.write(512);
    state = LOCKED;
}

void updateLockStatusColor() {
    int r, g, b = LOW;
    switch(state) {
      case UNLOCKED:
        r = LOW;
        g = HIGH;
        break;
      case LOCKED:
        r = HIGH;
        g = LOW;
    }
    digitalWrite(redPin, r);
    digitalWrite(greenPin, g);
    digitalWrite(bluePin, b);
}

