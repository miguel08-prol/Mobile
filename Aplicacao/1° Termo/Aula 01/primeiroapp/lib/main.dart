import 'package:flutter/material.dart';

void main() {
runApp(primeiroapp());
}

class primeiroapp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
home: Scaffold(
appBar: AppBar(title: Text('Hello word app'),) ,
body: Center(
child: Text('Olá Mundo!!')),
),
);
}
}