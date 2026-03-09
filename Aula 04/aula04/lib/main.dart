import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false,
  home: InterruptorApp(),
  ));
}

class InterruptorApp extends StatefulWidget{
@override 

_InterruptorAppState createState() => _InterruptorAppState();
}

class _InterruptorAppState extends State<InterruptorApp> {
  bool estaAcesso = false;  


void alternarluz() {
  setState(() {
  estaAcesso = !estaAcesso; // ! => Inverte o valor
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: estaAcesso ? Colors.black : Colors.white,
    appBar: AppBar(
      title: Text(
        'Interruptor',
        style: TextStyle(color: estaAcesso ? Colors.white : Colors.black),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Icon(
            estaAcesso ? Icons.lightbulb : Icons.lightbulb_outline,
            size: 100,
            color: estaAcesso ? Colors.white : Colors.black,
          ),
          ElevatedButton(
            onPressed: alternarluz,
            style: ElevatedButton.styleFrom(
              backgroundColor: estaAcesso ? Colors.white : Colors.black,
            ),
            child: Text(
              'Interruptor',
              style: TextStyle(color: estaAcesso ? Colors.black : Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}
}