import 'package:flutter/material.dart';
import 'package:full_app/styles.dart';

class mapScreen extends StatelessWidget{
    const mapScreen({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: const Text('Map'),
      ),
      body: Center(
        child: const Text('(map)'),
      ),
    );
  }
}