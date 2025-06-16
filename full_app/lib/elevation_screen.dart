import 'package:flutter/material.dart';
import 'package:full_app/styles.dart';

class ElevationScreen extends StatelessWidget{
    const ElevationScreen({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: const Text('Elevation'),
      ),
      body: Center(
        child: const Text('1000 ft'),
      ),
    );
  }
}