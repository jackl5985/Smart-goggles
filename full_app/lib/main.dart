import 'package:flutter/material.dart';
import 'package:full_app/all_time.dart';
import 'package:full_app/mrd.dart';
import 'package:full_app/current_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizontal Scroll Screens',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HorizontalPager(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HorizontalPager extends StatefulWidget {
  const HorizontalPager({super.key});

  @override
  State<HorizontalPager> createState() => _HorizontalPagerState();
}

class _HorizontalPagerState extends State<HorizontalPager> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(), // Adds the "pull then snap" effect
      children: <Widget>[
        todayScreen(),
        allTimeScreen(),
        recentScreen(),
      ],
    );
  }
}

