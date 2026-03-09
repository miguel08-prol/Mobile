import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EmocaoApp(),
  ));
}

class EmocaoApp extends StatefulWidget {
  @override
  _EmocaoAppState createState() => _EmocaoAppState();
}

class _EmocaoAppState extends State<EmocaoApp> {
  int emocoes = 1;

  String getEmoji() {
    switch (emocoes) {
      case 1: return "🙂";
      case 2: return "😢";
      case 3: return "😡";
      case 4: return "🤪";
      default: return "😶";
    }
  }

  Color getCor() {
    switch (emocoes) {
      case 1: return Colors.yellow.shade100;
      case 2: return Colors.blue.shade200;
      case 3: return Colors.red.shade200;
      case 4: return Colors.orange.shade200;
      default: return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getCor(),
      appBar: AppBar(
        title: Text('Sistema de Emoções'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getEmoji(),
                style: TextStyle(fontSize: 120),
              ),
              SizedBox(height: 30),
              Text(
                "Digite um número (1 a 4):",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: "1",
                  ),
                  onChanged: (valor) {
                    setState(() {
                      emocoes = int.tryParse(valor) ?? 0;
                    });
                  },
                ),
              ),
              Text(
                "1: Normal | 2: Triste | 3: Raiva | 4: Bobo",
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}