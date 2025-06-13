import 'package:flutter/material.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildStatBox(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black),
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
              icon: const Icon(Icons.battery_6_bar, color: Colors.green),
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
                  'Wed, Jun 12 2025 • 12:34 PM', // Dummy time
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 4, color: Colors.black, offset: Offset(1, 1))
                    ],
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
                      _buildStatBox('72', 'Heart Rate'),
                      _buildStatBox('98', 'Oxygen'),
                      _buildStatBox('3.5', 'Speed'),
                      _buildStatBox('1500', 'Steps'),
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
