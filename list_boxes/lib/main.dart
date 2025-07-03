import 'package:flutter/material.dart';
import 'package:list_boxes/styles.dart';
import 'package:list_boxes/util/listBox.dart';

void main() {
  runApp(const MyListApp());
}


class MyListApp extends StatelessWidget {
  const MyListApp({super.key});

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'ListBox Demo',
    home: const HomeScreen(), // move the scaffold here
  );
}
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  //Alert box \/ \/

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: lightGray,
          title: const Text('Start Recording', style: TextStyle(fontWeight: FontWeight.bold),),
          content: const Text('Would you like to start recording your ski day?', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: lightGray,
                ),
                  child:
                    Text('Close', style: TextStyle(fontSize: 16, color: darkFontColor),),
                ),
            ),
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: darkFontColor,
                      width: 1,
                      ),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 1)],
                ),
                  child:
                    Text('START', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                ),
                ),
          ],
        );
      },
    );
  }

  //end of showAlertDialog widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vertical List Demo')),
      body: const ListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAlertDialog(context),
        child: const Icon(Icons.add_alert),
      ),
    );
  }
}


class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        listBox(
          location: "Eldora", 
          topSpeed: "48", 
          distance: "21", 
          movingTime: 3000, 
          date: "6/30/25",
          backgroundColor: lightGray,),
        listBox(
          location: "Northstar", 
          topSpeed: "33", 
          distance: "42", 
          movingTime: 1876, 
          date: "2/3/25",
          backgroundColor: lightGray,),
        listBox(
          location: "Copper Mtn", 
          topSpeed: "51", 
          distance: "22", 
          movingTime: 1234, 
          date: "1/12/25",
          backgroundColor: lightGray,),
        listBox(
          location: "Eldora", 
          topSpeed: "29", 
          distance: "77", 
          movingTime: 12324, 
          date: "10/11/25",
          backgroundColor: lightGray,),
          ],
    );
  }
}
