import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: JogoApp(),
  ));
}

class JogoApp extends StatefulWidget {
  @override
  _JogoAppState createState() => _JogoAppState();
}

class _JogoAppState extends State<JogoApp> {
  IconData iconeComputador = Icons.help_outline;
  String resultado = "Escolha uma opção";
  int pontosJogador = 0;
  int pontosComputador = 0;
  List opcoes = ["pedra", "papel", "tesoura"];

  void jogar(String escolhaUsuario) {
    int numero = Random().nextInt(3);
    String escolhaComputador = opcoes[numero];

    setState(() {
      if (escolhaComputador == "pedra") {
        iconeComputador = Icons.landscape;
      } else if (escolhaComputador == "papel") {
        iconeComputador = Icons.pan_tool;
      } else {
        iconeComputador = Icons.content_cut;
      }

      if (escolhaUsuario == escolhaComputador) {
        resultado = "Empate!";
      } else if (
        (escolhaUsuario == "pedra" && escolhaComputador == "tesoura") ||
        (escolhaUsuario == "papel" && escolhaComputador == "pedra") ||
        (escolhaUsuario == "tesoura" && escolhaComputador == "papel")
      ) {
        pontosJogador++;
        resultado = "Você venceu!";
      } else {
        pontosComputador++;
        resultado = "Computador venceu!";
      }
      
      if (pontosJogador >= 10) {
        resultado = "Você ganhou o campeonato!";
        resetarPlacar();
      } else if (pontosComputador >= 10) {
        resultado = "O PC ganhou o campeonato!";
        resetarPlacar();
      }
    });
  }

  void resetarPlacar() {
    setState(() {
      pontosJogador = 0;
      pontosComputador = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedra Papel Tesoura"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Escolha do Computador:", style: TextStyle(fontSize: 18)),
            Icon(iconeComputador, size: 100, color: Colors.blue),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                resultado,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "Você: $pontosJogador  |  PC: $pontosComputador",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.landscape, size: 40),
                  onPressed: () => jogar("pedra"),
                  tooltip: "Pedra",
                ),
                IconButton(
                  icon: Icon(Icons.pan_tool, size: 40),
                  onPressed: () => jogar("papel"),
                  tooltip: "Papel",
                ),
                IconButton(
                  icon: Icon(Icons.content_cut, size: 40),
                  onPressed: () => jogar("tesoura"),
                  tooltip: "Tesoura",
                ),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: resetarPlacar,
              icon: Icon(Icons.refresh),
              label: Text("Resetar Placar"),
            ),
          ],
        ),
      ),
    );
  }
}
