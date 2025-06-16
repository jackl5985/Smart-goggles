import 'package:flutter/material.dart';
import 'package:full_app/styles.dart';

class prScreen extends StatelessWidget{
    const prScreen({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: const Text('Personal Records'),
      ),
      body: Center(
        child: Column(
          children: [
             Text('1000 ft'),
             Text('40 mph'),
          ]
      ),
          
        )
    );
  }
}