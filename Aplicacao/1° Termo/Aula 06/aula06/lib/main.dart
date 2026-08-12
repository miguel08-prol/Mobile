import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SalvarTextoApp(),
  ));
}

class SalvarTextoApp extends StatefulWidget {
  @override
  _SalvarTextoAppState createState() => _SalvarTextoAppState();
}

class _SalvarTextoAppState extends State<SalvarTextoApp> {
  TextEditingController controller = TextEditingController();
  String textoSalvo = ""; // Padrão camelCase

  void salvarTexto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("texto", controller.text);
    setState(() {
      textoSalvo = controller.text;
    });
  }

  void carregarTexto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      textoSalvo = prefs.getString("texto") ?? ""; 
    });
  }

  @override
  void initState() {
    super.initState();
    carregarTexto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Salvar dados")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "Digite algo"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarTexto,
              child: Text("Salvar"),
            ),
            SizedBox(height: 20),
            Text(
              "Salvo: $textoSalvo",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
