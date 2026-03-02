import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PaginaContador(),
    debugShowCheckedModeBanner: false, 
  ));
}

class PaginaContador extends StatefulWidget {
  @override
  PaginaContadorState createState() => PaginaContadorState();
}

class PaginaContadorState extends State<PaginaContador> {
  int contador = 0;

  void increment() {
    setState(() {
      contador++;
    });
  }

  void decrement() {
    setState(() {
      contador--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meu App Interativo")),
      body: Center(
        child: Text(
          "Cliques: $contador",
          style: TextStyle(fontSize: 30),
        ),
      ),
      // Para usar dois botões, usamos um Column ou Row no floatingActionButton
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: increment,
            child: Icon(Icons.add),
            heroTag: "btn1", // Tag única para evitar erros de navegação
          ),
          SizedBox(height: 10), // Espaço entre os botões
          FloatingActionButton(
            onPressed: decrement,
            child: Icon(Icons.remove),
            heroTag: "btn2",
          ),
        ],
      ),
    );
  }
}
