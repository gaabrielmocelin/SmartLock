#include <Servo.h>

#define portaTranca 7

Servo tranca;

const int button1Pin = 4;
const int button2Pin = 5;
const int button3Pin = 6;

const int piezoPin = 3;

const int redPin = 10;
const int greenPin = 9;
const int bluePin = 8;

const int trigPin = 11;
const int echoPin = 12;

long duration, distance;

int button1State = 0;
int button2State = 0;
int button3State = 0;

// Lock stuff
enum LockState { LOCKED, UNLOCKED };
LockState state;

// Door stuff
enum DoorState { OPEN, CLOSED };
DoorState doorState;

const unsigned long int LOCK_UPDATE_DELAY = 600;
unsigned long int lockUpdateTimestamp;
boolean isLockUpdating = false;

const unsigned long int LOCK_ACTION_TIMEOUT_DELAY = 5000;
unsigned long int lockActionTimeoutTimestamp;
boolean isLockActionOnTimeout = false;

const unsigned long int UNLOCK_ACTION_TIMEOUT_DELAY = 5000;
unsigned long int unlockActionTimeoutTimestamp;
boolean isUnlockActionOnTimeout = false;

const unsigned long int DOOR_STATUS_UPDATE_DELAY = 500;
unsigned long int doorStatusChangeTimestamp;
boolean isUpdatingDoorStatus = false;

const unsigned long int PROXIMITY_UNLOCK_ACTION_TIMEOUT_DELAY = 10000;
unsigned long int proximityUnlockActionTimeoutTimestamp;
boolean isProximityUnlockActionOnTimeout = false;

// Bluetooth commands

enum LockCommand {  LOCK_COMMAND = 'L',
                    UNLOCK_COMMAND = 'U',
                    PROXIMITY_UNLOCK_COMMAND = 'P',
                    STATUS_COMMAND = 'S'
                 };

enum LockMessage {  BUZZER_SENDCOMMAND = 'B',
                    LOCKED_SENDCOMMAND = 'L',
                    UNLOCKED_SENDCOMMAND = 'U',
                    PROXIMITY_UNLOCKED_SENDCOMMAND = 'P',
                    OPEN_SENDCOMMAND = 'O'
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
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  lock();
  updateLockStatusColor();
  checkDoor();

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

  if (isProximityUnlockActionOnTimeout) {
    if (millis() - proximityUnlockActionTimeoutTimestamp >= PROXIMITY_UNLOCK_ACTION_TIMEOUT_DELAY) {
      isProximityUnlockActionOnTimeout = false;
    }
  }

  if (isUpdatingDoorStatus) {
    if (millis() - doorStatusChangeTimestamp >= DOOR_STATUS_UPDATE_DELAY) {
      isUpdatingDoorStatus = false;
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
        if (unlock())
          sendResponse(UNLOCKED_SENDCOMMAND);
        break;
      case PROXIMITY_UNLOCK_COMMAND:
        if (doorState == CLOSED && proximityUnlock()) {
            sendResponse(PROXIMITY_UNLOCKED_SENDCOMMAND);  
        }
        //do more stuff
        break;
      case LOCK_COMMAND:
        if (lock())
        sendResponse(LOCKED_SENDCOMMAND);
      case STATUS_COMMAND:
        switch (doorState) {
          case OPEN:
            sendResponse(OPEN_SENDCOMMAND);
            return;
          case CLOSED:
            break;
        }
        switch (state) {
          case LOCKED:
            sendResponse(LOCKED_SENDCOMMAND);
            break;
          case UNLOCKED:
            sendResponse(UNLOCKED_SENDCOMMAND);
        }
    }
  }
}

void sendResponse(LockMessage message) {
  Serial.write(message);
  delay(75);
}

void checkDoor() {
  //if (isDoorOpen) didOpenDoor(); --something like that

  // The sensor is triggered by a HIGH pulse of 10 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  digitalWrite(trigPin, LOW);
  delayMicroseconds(5);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Read the signal from the sensor: a HIGH pulse whose
  // duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  duration = pulseIn(echoPin, HIGH);

  // convert the time into a distance
  distance = (duration * .0343) / 2;

  if (doorState == CLOSED && checkForOpen()) {
    updateDoorStatus(OPEN);
  } else if (doorState == OPEN && checkForClose()) {
    updateDoorStatus(CLOSED);
  }
}

boolean isCheckingDoorOpening = false;
boolean isCheckingDoorClosing = false;
unsigned long int checkingDoorTimestamp;
const unsigned long int CHECK_DOOR_DURATION = 300;

boolean checkForOpen() {
  if (!isCheckingDoorOpening) {
    isCheckingDoorOpening = true;
    isCheckingDoorClosing = false;  
    checkingDoorTimestamp = millis();
    return false;
  }

  if (distance < 15) {
    isCheckingDoorOpening = false;   
    return false; 
  } else if (millis() - checkingDoorTimestamp >= CHECK_DOOR_DURATION) {
    return true;
  }
}

boolean checkForClose() {
  if (!isCheckingDoorClosing) {
    isCheckingDoorClosing = true;
    isCheckingDoorOpening = false;
    checkingDoorTimestamp = millis();
    return false;
  }

  if (distance >= 15) {
    isCheckingDoorClosing = false;
    return false;
  } else if (millis() - checkingDoorTimestamp >= CHECK_DOOR_DURATION) {
    
    return true;
  }
}

void updateDoorStatus(DoorState newState) {
  if (isUpdatingDoorStatus) return;
  isUpdatingDoorStatus = true;
  doorStatusChangeTimestamp = millis();
  
  doorState = newState;
  switch(doorState) {
    case OPEN:
    sendResponse(OPEN_SENDCOMMAND);
    break;
    case CLOSED:
    didCloseDoor();
  }
}

void didCloseDoor() {
  if (lock())
    sendResponse(LOCKED_SENDCOMMAND);
  timeOutProximityUnlockAction();
}

void checkLockButton() {
  if (isLockUpdating) return;

  button1State = digitalRead(button1Pin);
  button2State = digitalRead(button2Pin);

  if (button1State == LOW || button2State == LOW) {
    switch (state) {
      case LOCKED:
        if (unlock())
          sendResponse(UNLOCKED_SENDCOMMAND);
        break;
      case UNLOCKED:
        if (lock())
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

boolean unlock() {
  if (isUnlockActionOnTimeout) return false;

  lockUpdateTimestamp = millis();
  isLockUpdating = true;
  tranca.write(0);
  state = UNLOCKED;

  return true;
}

boolean lock() {
//  if (isLockActionOnTimeout) return false;
  
  lockUpdateTimestamp = millis();
  isLockUpdating = true;
  tranca.write(150);
  state = LOCKED;

  return true;
}

boolean proximityUnlock() {
  if (isProximityUnlockActionOnTimeout) return false;

  return unlock();
}

void timeOutLockAction() {
  lockActionTimeoutTimestamp = millis();
  isLockActionOnTimeout = true;
}

void timeOutUnlockAction() {
  unlockActionTimeoutTimestamp = millis();
  isUnlockActionOnTimeout = true;
}

void timeOutProximityUnlockAction() {
  proximityUnlockActionTimeoutTimestamp = millis();
  isProximityUnlockActionOnTimeout = true;
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

