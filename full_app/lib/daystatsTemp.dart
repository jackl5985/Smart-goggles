import 'package:flutter/material.dart';
import 'styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildStatBox(String number, String unit, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: darkBlue.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
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
              style: const TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomCenter,
              child:
            Text(
              unit,
              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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
            const Text('Goggles', style: TextStyle(fontSize: 20, color: Colors.blue),),
            const SizedBox(width: 8),
            const Icon(Icons.circle, color: Colors.red,),
            const Spacer(),
            Transform.rotate(angle: 90),
            IconButton(
              icon: Transform.rotate(
                angle: -3.14/2,
                child: Icon(Icons.battery_6_bar, color: Colors.green),
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
            'images/mountains.png', // Replace with your image path
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(.5),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(height: MediaQuery.of(context).size.height*0.3),
                const Text(
                  'Wed, Jun 12 2025', // Dummy date
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: darkFontColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '12:34 PM', // Dummy time
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: darkFontColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'ALL TIME', // Dummy location
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const Spacer(flex: 1),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStatBox('55', 'mph','Top Speed'),
                      _buildStatBox('16', 'k','Vertical Feet'),
                      _buildStatBox('2', 'PRs','Set Today'),
                      _buildStatBox('10', 'mi','Distance'),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
