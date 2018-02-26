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

// Lock stuff
enum LockState { LOCKED, UNLOCKED };
LockState state;

const unsigned long int LOCK_UPDATE_DELAY = 600;
unsigned long int lockUpdateTimestamp;
boolean isLockUpdating = false;

const unsigned long int LOCK_ACTION_TIMEOUT_DELAY = 5000;
unsigned long int lockActionTimeoutTimestamp;
boolean isLockActionOnTimeout = false;

const unsigned long int UNLOCK_ACTION_TIMEOUT_DELAY = 5000;
unsigned long int unlockActionTimeoutTimestamp;
boolean isUnlockActionOnTimeout = false;

// Bluetooth commands

enum LockCommand {  LOCK_COMMAND = 'L',
                    UNLOCK_COMMAND = 'U',
                    PROXIMITY_UNLOCK_COMMAND = 'P'
                 };

enum LockMessage {  BUZZER_SENDCOMMAND = 'B',
                    LOCKED_SENDCOMMAND = 'L',
                    UNLOCKED_SENDCOMMAND = 'U',
                    PROXIMITY_UNLOCKED_SENDCOMMAND = 'P'
                 };

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
  checkLock();

  checkButtons();

  checkBluetoothMessages();

  checkDoor();
}

void checkLock() {
  if (isLockUpdating) {
    if (millis() - lockUpdateTimestamp >= LOCK_UPDATE_DELAY) {
      isLockUpdating = false;
      updateLockStatusColor();
    }
  }

  if (isLockActionOnTimeout) {
    if (millis() - lockActionTimeoutTimestamp >= LOCK_ACTION_TIMEOUT_DELAY) {
      isLockActionOnTimeout = false;
    }
  }

  if (isUnlockActionOnTimeout) {
    if (millis() - unlockActionTimeoutTimestamp >= UNLOCK_ACTION_TIMEOUT_DELAY) {
      isUnlockActionOnTimeout = false;
    }
  }
}

void checkButtons() {
  checkLockButton();
  checkBuzzerButton();
}

void checkBluetoothMessages() {
  if (Serial.available() > 0) {
    byteRead = Serial.read();
    //Serial.write(byteRead);

    switch (byteRead) {
      case UNLOCK_COMMAND:
        unlock();
        sendResponse(UNLOCKED_SENDCOMMAND);
        break;
      case PROXIMITY_UNLOCK_COMMAND:
        unlock();
        sendResponse(PROXIMITY_UNLOCKED_SENDCOMMAND);
        //do more stuff
        break;
      case LOCK_COMMAND:
        lock();
        sendResponse(LOCKED_SENDCOMMAND);
    }
  }
}

void sendResponse(LockMessage message) {
  Serial.write(message);
  delay(75);
}

void checkDoor() {
  //if (isDoorOpen) didOpenDoor(); --something like that
}

void didCloseDoor() {
  lock();
}

void checkLockButton() {
  if (isLockUpdating) return;

  button1State = digitalRead(button1Pin);
  button2State = digitalRead(button2Pin);

  if (button1State == LOW || button2State == LOW) {
    switch (state) {
      case LOCKED:
        unlock();
        sendResponse(UNLOCKED_SENDCOMMAND);
        break;
      case UNLOCKED:
        lock();
        sendResponse(LOCKED_SENDCOMMAND);
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
  if(isLockActionOnTimeout) return;
  
  lockUpdateTimestamp = millis();
  isLockUpdating = true;
  tranca.write(0);
  state = UNLOCKED;
}

void lock() {
  lockUpdateTimestamp = millis();
  isLockUpdating = true;
  tranca.write(150);
  state = LOCKED;
}

void timeOutLockAction() {
  lockActionTimeoutTimestamp = millis();
  isLockActionOnTimeout = true;
}

void timeOutUnlockAction() {
  unlockActionTimeoutTimestamp = millis();
  isUnlockActionOnTimeout = true;
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

