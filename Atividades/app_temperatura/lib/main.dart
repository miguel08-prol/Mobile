import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TemperaturaApp(),
  ));
}

class TemperaturaApp extends StatefulWidget {
  @override
  _TemperaturaAppState createState() => _TemperaturaAppState();
}

class _TemperaturaAppState extends State<TemperaturaApp> {
  int temperatura = 20;

  void aumentar() {
    setState(() {
      temperatura++;
    });
  }

  void diminuir() {
    setState(() {
      temperatura--;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color corFundo;
    String emoji;
    String status;

    if (temperatura < 15) {
      corFundo = Colors.blue;
      emoji = "❄️"; 
      status = "Frio";
    } else if (temperatura < 30) {
      corFundo = Colors.green;
      emoji = "😊"; 
      status = "Agradável";
    } else {
      corFundo = Colors.red;
      emoji = "🔥"; 
      status = "Quente";
    }

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        title: Text("Termômetro Flutter"),
        backgroundColor: Colors.black26,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 100),
            ),
            Text(
              "$temperatura°C",
              style: TextStyle(
                  fontSize: 80, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
              ),
            ),
            Text(
              status,
              style: TextStyle(
                  fontSize: 28, 
                  color: Colors.white70
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: diminuir,
                  child: Text("-", style: TextStyle(fontSize: 30)),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 60),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: aumentar,
                  child: Text("+", style: TextStyle(fontSize: 30)),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 60),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}