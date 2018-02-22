#include <Servo.h>

#define portaTranca 7

Servo tranca;

const int button1Pin = 4;
const int button2Pin = 5;
const int button3Pin = 6;

const int piezoPin = 3;

const int redPin = 11;
const int greenPin = 10;
const int bluePin = 9;

int button1State = 0;
int button2State = 0;
int button3State = 0;

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
  pinMode(piezoPin, OUTPUT);

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
      checkLockButton();
  }

  checkBuzzerButton();
  
  if (Serial.available() > 0) {
    byteRead = Serial.read();
    Serial.write(byteRead);

    if (byteRead == 'U') {
      unlock();
    } else if (byteRead == 'L') {
      lock();
    }
  }
}

void checkLockButton() {  
  button1State = digitalRead(button1Pin);
  button2State = digitalRead(button2Pin);
  
  if (button1State == LOW || button2State == LOW) {
    switch(state) {
      case LOCKED:
        unlock();
        break;
      case UNLOCKED:
        lock();
    }
  }
}

void checkBuzzerButton() {
  button3State = digitalRead(button3Pin);
  
  if (button3State == LOW) {
    tone(piezoPin, 2000);
  } else {
    noTone(piezoPin);
  }
}

void unlock() {
    lockUpdateTimestamp = millis();
    updatingLock = true;
    tranca.write(0);
    state = UNLOCKED;
}

void lock() {
    lockUpdateTimestamp = millis();
    updatingLock = true;
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

