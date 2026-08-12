import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(home: PaginaSorteador()));
}

class PaginaSorteador extends StatefulWidget{
@override
PaginaSorteadorState createState() => PaginaSorteadorState();
}

class PaginaSorteadorState extends State<PaginaSorteador> {
int numeroSorteado = 0;

Random random = Random();

void sortearNumero() {
// Esse comando faz a tela atualizar(Muito importante),para aparecer na tela,mesmo sem ele o comando funciona so nao atualiza em tempo real na tela
setState(() {
 numeroSorteado = random.nextInt(11);
});
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text("Meu app Interativo2"),),
body: Center(child: Text("Número Sorteado: $numeroSorteado",
style: TextStyle(fontSize: 30),
)
),
floatingActionButton: FloatingActionButton(onPressed: sortearNumero,child: Icon(Icons.refresh),
),
);
}
}