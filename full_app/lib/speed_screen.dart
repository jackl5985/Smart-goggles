import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'speed_smoothing.dart';

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
  _sendTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
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
