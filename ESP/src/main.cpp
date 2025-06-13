// Optimized ESP32 code for real-time BLE display with smoothing
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Adafruit_GFX.h>
#include <Adafruit_ST7789.h>
#include <SPI.h>

#define SERVICE_UUID        "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_UUID "abcd1234-ab12-cd34-ef56-1234567890ab"

#define TFT_CS    15
#define TFT_RST   5
#define TFT_DC    2

Adafruit_ST7789 tft = Adafruit_ST7789(TFT_CS, TFT_DC, TFT_RST);

String currentTime = "--:--";
String currentSpeed = "--";

String lastTime = "";
String lastSpeed = "";

class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    std::string rxValue = pCharacteristic->getValue();
    if (rxValue.length() > 0) {
      String data = String(rxValue.c_str());
      int sep = data.indexOf('|');
      if (sep != -1) {
        String newTime = data.substring(0, sep);
        String newSpeed = data.substring(sep + 1);

        // Only update if values actually changed
        if (newTime.length() > 0 && newTime != currentTime) {
          currentTime = newTime;
        }
        if (newSpeed.length() > 0 && newSpeed != currentSpeed) {
          currentSpeed = newSpeed;
        }
      }
    }
  }
};


void drawScreen() {
  tft.fillRect(0, 50, 240, 30, ST77XX_BLACK);
  tft.setCursor(60, 60);
  tft.print("Time: ");
  tft.print(currentTime);

  tft.fillRect(0, 110, 240, 30, ST77XX_BLACK);
  tft.setCursor(60, 120);
  tft.print("Speed: ");
  tft.print(currentSpeed);
}

void setup() {
  Serial.begin(115200);

  // Setup BLE
  BLEDevice::init("ESP32_BLE");
  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);
  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_WRITE
  );

  pCharacteristic->setCallbacks(new MyCallbacks());
  pCharacteristic->addDescriptor(new BLE2902());
  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);
  pAdvertising->setMinPreferred(0x12);
  pAdvertising->start();

  // Setup display
  tft.init(240, 280);
  tft.setRotation(2);
  tft.fillScreen(ST77XX_BLACK);
  tft.setTextColor(ST77XX_WHITE);
  tft.setTextSize(2);

  drawScreen();
}

unsigned long lastRefresh = 0;
const unsigned long refreshInterval = 200; // ms

void loop() {
  unsigned long now = millis();
  if (now - lastRefresh >= refreshInterval) {
    lastRefresh = now;

    // Only redraw if something changed
    if (currentTime != lastTime || currentSpeed != lastSpeed) {
      drawScreen();
      lastTime = currentTime;
      lastSpeed = currentSpeed;
    }
  }
}