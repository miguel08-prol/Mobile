import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo,
      brightness: Brightness.light,
    ),
    home: AppNotas(),
  ));
}

class NotaItem {
  String texto;
  bool concluida;
  NotaItem({required this.texto, this.concluida = false});

  Map<String, dynamic> toMap() => {'t': texto, 'c': concluida ? 1 : 0};
  factory NotaItem.fromRaw(String raw) {
    final parts = raw.split('|');
    return NotaItem(texto: parts[0], concluida: parts[1] == '1');
  }
}

class AppNotas extends StatefulWidget {
  @override
  _AppNotasState createState() => _AppNotasState();
}

class _AppNotasState extends State<AppNotas> {
  List<NotaItem> notas = [];
  final TextEditingController controller = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    carregarNotas();
  }

  void salvarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listaString = notas.map((n) => "${n.texto}|${n.concluida ? 1 : 0}").toList();
    prefs.setStringList("notas_v2", listaString);
  }

  void carregarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? salvas = prefs.getStringList("notas_v2");
    if (salvas != null) {
      for (var i = 0; i < salvas.length; i++) {
        notas.add(NotaItem.fromRaw(salvas[i]));
        _listKey.currentState?.insertItem(i);
      }
      setState(() {});
    }
  }

  void adicionarNota() {
    if (controller.text.isNotEmpty) {
      final nova = NotaItem(texto: controller.text);
      setState(() {
        notas.insert(0, nova);
      });
      _listKey.currentState?.insertItem(0);
      controller.clear();
      salvarNotas();
    }
  }

  void alternarStatus(int index) {
    setState(() {
      notas[index].concluida = !notas[index].concluida;
    });
    salvarNotas();
  }

  void removerNota(int index) {
    final removida = notas[index];
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => buildItem(removida, animation, index, removendo: true),
    );
    setState(() {
      notas.removeAt(index);
    });
    salvarNotas();
  }

  void limparTudo() {
    for (var i = notas.length - 1; i >= 0; i--) {
      removerNota(i);
    }
  }

  Widget buildItem(NotaItem nota, Animation<double> animation, int index, {bool removendo = false}) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: nota.concluida ? Colors.green.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))
            ],
            border: Border.all(
              color: nota.concluida ? Colors.green.withOpacity(0.3) : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            leading: GestureDetector(
              onTap: removendo ? null : () => alternarStatus(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: nota.concluida ? Colors.green : Colors.transparent,
                  border: Border.all(color: nota.concluida ? Colors.green : Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(Icons.check, size: 20, color: nota.concluida ? Colors.white : Colors.transparent),
                ),
              ),
            ),
            title: Text(
              nota.texto,
              style: TextStyle(
                decoration: nota.concluida ? TextDecoration.lineThrough : null,
                color: nota.concluida ? Colors.grey : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete_sweep_outlined, color: Colors.redAccent.withOpacity(0.7)),
              onPressed: removendo ? null : () => removerNota(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Minhas Notas", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1C2E))),
                      Text("${notas.where((n) => !n.concluida).length} pendentes de ${notas.length} no total", 
                        style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  if (notas.isNotEmpty)
                    TextButton.icon(
                      onPressed: limparTudo,
                      icon: Icon(Icons.clear_all, color: Colors.redAccent),
                      label: Text("Limpar", style: TextStyle(color: Colors.redAccent)),
                    )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
                ),
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => adicionarNota(),
                  decoration: InputDecoration(
                    hintText: "Adicionar nova tarefa...",
                    prefixIcon: Icon(Icons.add_task, color: Colors.indigo),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: notas.isEmpty
                  ? Center(child: Opacity(opacity: 0.5, child: Image.network("https://cdn-icons-png.flaticon.com/512/6194/6194029.png", width: 150)))
                  : AnimatedList(
                      key: _listKey,
                      initialItemCount: notas.length,
                      padding: EdgeInsets.only(bottom: 100),
                      itemBuilder: (context, index, animation) => buildItem(notas[index], animation, index),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: adicionarNota,
        backgroundColor: Colors.indigo,
        label: Text("Salvar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}