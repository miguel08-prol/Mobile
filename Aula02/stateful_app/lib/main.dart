import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: PaginaContador()));
}

class PaginaContador extends StatefulWidget{
@override
PaginaContadorState createState() => PaginaContadorState();
}

class PaginaContadorState extends State<PaginaContador> {
int contador = 0;
void increment() {
// Esse comando faz a tela atualizar(Muito importante),para aparecer na tela,mesmo sem ele o comando funciona so nao atualiza em tempo real na tela
setState(() {
  contador++;
});
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text("Meu app Interativo"),),
body: Center(child: Text("Cliques: $contador",
style: TextStyle(fontSize: 30),
)
),
floatingActionButton: FloatingActionButton(onPressed: increment,child: Icon(Icons.add),
),
);
}
}

