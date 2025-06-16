import 'package:flutter/material.dart';
import 'package:full_app/elevation_screen.dart';
import 'package:full_app/map.dart';
import 'package:full_app/menu.dart';
import 'package:full_app/prs.dart';
import 'styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

Widget _buildStatBox(String number, String unit, String label, Widget? screen, BuildContext context, Color color,) {
  final statContent = Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                unit,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    ),
  );

  final decoration = BoxDecoration(
    color: color.withOpacity(0.8),
    borderRadius: BorderRadius.circular(16),
  );

  if (screen == null) {
    return Container(
      decoration: decoration,
      child: statContent,
    );
  } else {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.zero,
        elevation: 4,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: statContent,
    );
  }
}



  Widget _buildPage({
    required String date,
    required String time,
    required String location,
    required List<Widget> stats,
    required BuildContext context,
  }) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Text(
          date,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: darkFontColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          time,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: darkFontColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          location,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            physics: const NeverScrollableScrollPhysics(),
            children: stats,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 12),
            const Text('Goggles', style: TextStyle(fontSize: 20, color: Colors.blue)),
            const SizedBox(width: 8),
            const Icon(Icons.circle, color: Colors.red),
            const Spacer(),
            IconButton(
              icon: Transform.rotate(
                angle: -3.14 / 2,
                child: const Icon(Icons.battery_6_bar, color: Colors.green),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/mountains.png',
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(.5),
          ),
          SafeArea(
            child: PageView(
              scrollDirection: Axis.horizontal,
              physics: const PageScrollPhysics(),
              children: [
                _buildPage(
                  context: context,
                  date: 'Today\'s Stats',
                  time: '12:34 PM',
                  location: 'Eldora Mountain',
                  stats: [
                    _buildStatBox('55', 'mph', 'Top Speed', MainMenu(), context, darkRed),
                    _buildStatBox('16', 'k', 'Vertical Feet', ElevationScreen(), context, darkRed),
                    _buildStatBox('2', 'PRs', 'Set Today', prScreen(), context, darkRed),
                    _buildStatBox('10', 'mi', 'Distance', mapScreen(), context, darkRed),
                  ],
                ),
                _buildPage(
                  context: context,
                  date: 'Thu, Jun 13 2025',
                  time: '3:45 PM',
                  location: 'All Time',
                  stats: [
                    _buildStatBox('42', 'mph', 'Top Speed', null, context, darkBlue),
                    _buildStatBox('9', 'k', 'Vertical Feet', null, context, darkBlue),
                    _buildStatBox('1', 'PR', 'Set Today', null, context, darkBlue),
                    _buildStatBox('7.5', 'mi', 'Distance', null, context, darkBlue),
                  ],
                ),
                _buildPage(
                  context: context,
                  date: 'Fri, Jun 14 2025',
                  time: '10:21 AM',
                  location: 'Recent Day',
                  stats: [
                    _buildStatBox('37', 'mph', 'Top Speed', null, context, greenishBlue),
                    _buildStatBox('12', 'k', 'Vertical Feet', null, context, greenishBlue),
                    _buildStatBox('3', 'PRs', 'Set Today', null, context, greenishBlue),
                    _buildStatBox('9.1', 'mi', 'Distance', null, context, greenishBlue),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
