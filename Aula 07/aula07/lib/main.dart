import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
    home: AppBanco(),
  ));
}

class AppBanco extends StatefulWidget {
  @override
  _AppBancoState createState() => _AppBancoState();
}

class _AppBancoState extends State<AppBanco> {
  TextEditingController controller = TextEditingController();
  List<Map<String, dynamic>> tarefas = [];
  Database? _db;

  // Singleton para o Banco de Dados (Melhor performance)
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  _initDb() async {
    final caminho = await getDatabasesPath();
    final path = join(caminho, "banco_novo.db"); // Mudei o nome para resetar o banco

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute("CREATE TABLE tarefas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT)");
      },
    );
  }

  Future<void> inserirTarefa(String nome) async {
    final db = await database;
    await db.insert("tarefas", {"nome": nome});
    controller.clear();
    carregarTarefas();
  }

  Future<void> carregarTarefas() async {
    final db = await database;
    final lista = await db.query("tarefas", orderBy: "id DESC");
    setState(() {
      tarefas = lista;
    });
  }

  Future<void> deletarTarefa(int id) async {
    final db = await database;
    await db.delete("tarefas", where: "id = ?", whereArgs: [id]);
    carregarTarefas();
  }

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Minhas Tarefas", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Campo de entrada estilizado
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "O que precisa fazer?",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    if (controller.text.isNotEmpty) inserirTarefa(controller.text);
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                )
              ],
            ),
          ),
          // Lista de tarefas
          Expanded(
            child: tarefas.isEmpty
                ? Center(child: Text("Nenhuma tarefa por aqui! 😴"))
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: tarefas.length,
                    itemBuilder: (context, index) {
                      final item = tarefas[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo[100],
                            child: Text("${index + 1}", style: TextStyle(color: Colors.indigo)),
                          ),
                          title: Text(
                            item["nome"],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => deletarTarefa(item["id"]),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}