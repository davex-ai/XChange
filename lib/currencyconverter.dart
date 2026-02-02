import 'package:flutter/material.dart';

class Currencyconverter extends StatelessWidget {
  const Currencyconverter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('0', style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)), )
            TextField()
          ],
        ),
      ),
    );
  }
}
