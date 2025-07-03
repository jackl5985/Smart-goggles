import 'package:flutter/material.dart';
import 'package:list_boxes/styles.dart';

String formatSeconds(int seconds) {
  final duration = Duration(seconds: seconds);

  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final secs = duration.inSeconds % 60;

  if (hours > 0) {
    return "${hours} hrs, ${minutes} mins, ${secs}s";
  } else if (minutes > 0) {
    return "${minutes} mins, ${secs}s";
  } else {
    return "${secs}s";
  }
}


class listBox extends StatelessWidget {
  final String location;
  final  String topSpeed;
  final  String distance;
  final  int movingTime;
  final  String date;
  final  Color backgroundColor;

  listBox({
    required this.location,
    required this.topSpeed,
    required this.distance,
    required this.movingTime,
    required this.date,
    required this.backgroundColor,
  });
  @override

Widget build(BuildContext context){
    String formattedTime = formatSeconds(movingTime);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children:[ 
              Text(location, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color:darkFontColor)),
              const SizedBox(width: 8,),
              Image.asset('images/gogs.png',height: 22, fit: BoxFit.contain,), //change to images/$location.png for unique logo
              const Spacer(),
              Text(date, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            ]
          ),
          SizedBox(height: 6,),
          Row(
            children: [
              Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: Colors.white,
                      width: 1,
                      ),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 1)],
                ),
                child:
                SizedBox(
                  height: 30,
                  child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(topSpeed, style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),),
                            SizedBox(width: 4,),
                            Text("mph", style: TextStyle(fontSize: 6, color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        Text('Top Speed', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),),
                        
                      ],
                    )
                )
                ),
                const SizedBox(width: 8,),
              Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: greenishBlue,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: Colors.white,
                      width: 1,
                      ),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 1)],
                ),
                child:
                SizedBox(
                  height: 30,
                  child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(distance, style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),),
                            SizedBox(width: 4,),
                            Text("mi", style: TextStyle(fontSize: 6, color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        Text('Distance', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),),
                      ],
                    )
                )
                ),
                const SizedBox(width: 8,),
              Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 100, 185, 255),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: Colors.white,
                      width: 1,
                      ),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 1)],
                ),
                  child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(formattedTime, style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),),
                        Text('Time', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),),
                        
                      ],
                    )
                ),
            ],
          ),
            ],
          )
      );
  }
}