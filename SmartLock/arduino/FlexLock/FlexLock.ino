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

enum LockState { LOCKED, UNLOCKED };
const unsigned long int LOCK_DELAY = 600;
LockState state;
unsigned long int lockUpdateTimestamp;
boolean isUpdatingLock = false;

enum LockCommand {  LOCK_COMMAND = 'L',
                    UNLOCK_COMMAND = 'U',
                    PROXIMITY_UNLOCK_COMMAND = 'P' };

enum LockMessage {  BUZZER_SENDCOMMAND = 'B',
                    LOCKED_SENDCOMMAND = 'L',
                    UNLOCKED_SENDCOMMAND = 'U',
                    PROXIMITY_UNLOCKED_COMMAND = 'P' };

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
  if (isUpdatingLock) {
    if (millis() - lockUpdateTimestamp >= LOCK_DELAY) {
      isUpdatingLock = false;
      updateLockStatusColor();
    }
  } else {
    checkLockButton();
  }
  
  checkBuzzerButton();

  if (Serial.available() > 0) {
    byteRead = Serial.read();
    Serial.write(byteRead);

    if (byteRead == UNLOCK_COMMAND) {
      unlock();
    } else if (byteRead == LOCK_COMMAND) {
      lock();
    } else if (byteRead == PROXIMITY_UNLOCK_COMMAND) {
      unlock();
    }
  }
}

void checkLockButton() {
  button1State = digitalRead(button1Pin);
  button2State = digitalRead(button2Pin);

  if (button1State == LOW || button2State == LOW) {
    switch (state) {
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
    sendBuzzNotification();
  } else {
    noTone(piezoPin);
  }
}

void sendBuzzNotification() {
    Serial.write(BUZZER_SENDCOMMAND);
    delay(75);
}

void unlock() {
  lockUpdateTimestamp = millis();
  isUpdatingLock = true;
  tranca.write(0);
  state = UNLOCKED;
}

void lock() {
  lockUpdateTimestamp = millis();
  isUpdatingLock = true;
  tranca.write(150);
  state = LOCKED;
}

void updateLockStatusColor() {
  int r, g, b = LOW;
  switch (state) {
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

