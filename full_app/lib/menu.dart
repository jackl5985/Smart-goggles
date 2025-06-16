import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'time_screen.dart';
import 'speed_screen.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool isConnecting = false;
  bool isConnected = false;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? targetCharacteristic;
  Timer? _timeTimer;

  final serviceUuid = Guid("12345678-1234-1234-1234-1234567890ab");
  final characteristicUuid = Guid("abcd1234-ab12-cd34-ef56-1234567890ab");

  @override
  void initState() {
    super.initState();
    reconnectToDevice();
    _startTimeUpdates();
  }

  void _startTimeUpdates() {
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final now = DateTime.now();
      final formattedTime = DateFormat.Hm().format(now);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lastTime', formattedTime);
      sendData("$formattedTime|"); // Leave speed blank
    });
  }

  @override
  void dispose() {
    _timeTimer?.cancel();
    super.dispose();
  }

  Future<void> reconnectToDevice() async {
    setState(() {
      isConnecting = true;
    });

    await FlutterBluePlus.adapterState.where((s) => s == BluetoothAdapterState.on).first;

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));
    print("Scanning for ESP32_BLE...");

    FlutterBluePlus.scanResults.listen((results) async {
      for (var result in results) {
        if (result.device.name == "ESP32_BLE") {
          print("Found ESP32_BLE, attempting to connect...");
          await FlutterBluePlus.stopScan();

          try {
            await result.device.connect(autoConnect: false);
          } catch (e) {
            print("Connection failed: $e");
          }

          result.device.connectionState.listen((state) {
            if (state == BluetoothConnectionState.disconnected) {
              print("Disconnected — retrying...");
              reconnectToDevice();
            }
          });

          await setupDevice(result.device);
          return;
        }
      }
    });
  }

  Future<void> setupDevice(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid == serviceUuid) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid == characteristicUuid && characteristic.properties.write) {
              setState(() {
                isConnecting = false;
                isConnected = true;
                connectedDevice = device;
                targetCharacteristic = characteristic;
              });
              print("Bluetooth connected and ready.");
              return;
            }
          }
        }
      }
    } catch (e) {
      print("Service discovery failed: $e");
    }

    setState(() {
      isConnecting = false;
      isConnected = false;
    });
  }

  Future<void> sendData(String data) async {
    if (isConnected && targetCharacteristic != null) {
      try {
        await targetCharacteristic!.write(data.codeUnits, withoutResponse: false);
        print("Data sent: $data");
      } catch (e) {
        print("Write failed: $e — retrying connection");
        isConnected = false;
        reconnectToDevice();
      }
    } else {
      print("Not connected. Skipping send.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text('Goggle Test App')),
      body: Center(
        child: Builder(
          builder: (_) {
            if (isConnecting) {
              return const Text("Connecting to Bluetooth...", style: TextStyle(fontSize: 20));
            } else if (isConnected) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bluetooth_connected, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text(
                        'Connected to ESP32',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Time'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TimeScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text('Speed'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SpeedScreen(sendData: sendData),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bluetooth_disabled, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text(
                        'Disconnected',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Failed to connect to ESP32.", style: TextStyle(fontSize: 20)),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
