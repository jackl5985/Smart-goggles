import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const GogAppTS());
}

// Add this class to your Flutter code (e.g. near top of main.dart)
class SpeedProcessor {
  final List<_SpeedSample> _history = [];
  double _ema = 0.0;
  final double smoothingFactor = 0.2; // EMA alpha

  double get currentSpeed => _ema;

  void addSample(double speed, DateTime timestamp) {
    // Add raw sample
    _history.add(_SpeedSample(speed, timestamp));
    if (_history.length > 10) _history.removeAt(0);

    // Update EMA
    if (_ema == 0.0) {
      _ema = speed;
    } else {
      _ema = smoothingFactor * speed + (1 - smoothingFactor) * _ema;
    }
  }

  double interpolateSpeed(DateTime now) {
    if (_history.length < 2) return _ema;

    final recent = _history[_history.length - 1];
    final prev = _history[_history.length - 2];

    final dt = recent.timestamp.difference(prev.timestamp).inMilliseconds;
    final elapsed = now.difference(prev.timestamp).inMilliseconds;
    if (dt == 0) return recent.speed;

    final fraction = (elapsed / dt).clamp(0.0, 1.0);
    return prev.speed + (recent.speed - prev.speed) * fraction;
  }
}

class _SpeedSample {
  final double speed;
  final DateTime timestamp;
  _SpeedSample(this.speed, this.timestamp);
}

class GogAppTS extends StatelessWidget {
  const GogAppTS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainMenu(),
    );
  }
}

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
      appBar: AppBar(title: const Text('Goggle T/S App')),
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

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  late String _currentTime = "--:--";
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadLastTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDisplayTime();
    });
  }

  Future<void> _loadLastTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentTime = prefs.getString('lastTime') ?? "--:--";
    });
  }

  void _updateDisplayTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentTime = prefs.getString('lastTime') ?? _currentTime;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text('Time')),
      body: Center(
        child: Text(
          _currentTime,
          style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SpeedScreen extends StatefulWidget {
  final Function(String) sendData;
  const SpeedScreen({required this.sendData, super.key});

  @override
  _SpeedScreenState createState() => _SpeedScreenState();
}

class _SpeedScreenState extends State<SpeedScreen> {
  double _speed = 0.0;
  Position? _position;
  Timer? _sendTimer;
  StreamSubscription<Position>? _positionSub;
  final SpeedProcessor speedProcessor = SpeedProcessor();

  @override
void initState() {
  super.initState();
  _loadLastSpeed();
  _startTracking();

  // Send interpolated speed to ESP32 every 100 ms
  _sendTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
    final now = DateTime.now();
    final smoothedSpeed = speedProcessor.interpolateSpeed(now);
    final timeStr = DateFormat.Hm().format(now);
    widget.sendData("$timeStr|${smoothedSpeed.toStringAsFixed(2)}");
  });
}

  Future<void> _loadLastSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _speed = prefs.getDouble('lastSpeed') ?? 0.0;
    });
  }

  void _processNewSpeed(double newSpeed) {
  final now = DateTime.now();
  speedProcessor.addSample(newSpeed, now);
}

  Future<void> _startTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      _positionSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 1,
        ),
      ).listen((Position position) {
        setState(() {
          _position = position;
          _speed = (position.speed * 2.23694).clamp(0, 200);
        });

        _processNewSpeed(_speed);
      });
    }
  }

  @override
void dispose() {
  _positionSub?.cancel();
  _sendTimer?.cancel();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speed')),
      body: Center(
        child: _position == null
            ? const Text('Waiting for GPS...', style: TextStyle(fontSize: 20))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Speed: ${_speed.toStringAsFixed(2)} mph', style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 20),
                  Text('Lat: ${_position!.latitude}', style: const TextStyle(fontSize: 16)),
                  Text('Lon: ${_position!.longitude}', style: const TextStyle(fontSize: 16)),
                ],
              ),
      ),
    );
  }
}
