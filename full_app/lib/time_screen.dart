import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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