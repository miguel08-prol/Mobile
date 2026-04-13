import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(MaterialApp(
    scaffoldMessengerKey: scaffoldMessengerKey,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    home: AppCadastro(),
  ));
}

class AppCadastro extends StatefulWidget {
  @override
  _AppCadastroState createState() => _AppCadastroState();
}

class _AppCadastroState extends State<AppCadastro> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController descController = TextEditingController();
  
  List<Map<String, dynamic>> dados = [];
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  _initDb() async {
    final caminho = await getDatabasesPath();
    final path = join(caminho, "cadastro_v3.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute("""
          CREATE TABLE dados(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            titulo TEXT, 
            descricao TEXT,
            data TEXT,
            concluido INTEGER DEFAULT 0
          )
        """);
      },
    );
  }

  void mostrarAviso(String mensagem) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(mensagem),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.indigo,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> inserirItem() async {
    if (tituloController.text.isEmpty) return;
    final db = await database;
    await db.insert("dados", {
      "titulo": tituloController.text,
      "descricao": descController.text,
      "data": DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      "concluido": 0,
    });
    
    tituloController.clear();
    descController.clear();
    carregarItens();
    mostrarAviso("Item salvo com sucesso! ✅");
  }

  Future<void> carregarItens() async {
    final db = await database;
    final lista = await db.query("dados", orderBy: "concluido ASC, id DESC");
    setState(() {
      dados = lista;
    });
  }

  Future<void> alternarStatus(int id, int atual) async {
    final db = await database;
    await db.update(
      "dados", 
      {"concluido": atual == 0 ? 1 : 0}, 
      where: "id = ?", 
      whereArgs: [id]
    );
    carregarItens();
  }

  Future<void> deletarItem(int id) async {
    final db = await database;
    await db.delete("dados", where: "id = ?", whereArgs: [id]);
    carregarItens();
    mostrarAviso("Item removido! 🗑️");
  }

  Future<void> atualizarItem(int id, String novoTitulo, String novaDesc) async {
    final db = await database;
    await db.update(
      "dados",
      {"titulo": novoTitulo, "descricao": novaDesc},
      where: "id = ?",
      whereArgs: [id],
    );
    carregarItens();
  }

  void mostrarDialogoEdicao(BuildContext context, Map item) {
    TextEditingController editTitulo = TextEditingController(text: item['titulo']);
    TextEditingController editDesc = TextEditingController(text: item['descricao']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Editar Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: editTitulo, decoration: InputDecoration(labelText: "Título")),
            TextField(controller: editDesc, decoration: InputDecoration(labelText: "Descrição")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
          FilledButton(
            onPressed: () {
              atualizarItem(item['id'], editTitulo.text, editDesc.text);
              Navigator.pop(context);
            },
            child: Text("Salvar Alterações"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    carregarItens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F9),
      appBar: AppBar(
        title: Text("Cadastro Inteligente", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: tituloController,
                  decoration: InputDecoration(
                    labelText: "Título",
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 15),
                FilledButton.icon(
                  onPressed: inserirItem,
                  icon: Icon(Icons.add_task),
                  label: Text("ADICIONAR À LISTA"),
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: dados.isEmpty
                ? Center(child: Text("Sua lista está vazia ✨", style: TextStyle(color: Colors.grey, fontSize: 16)))
                : ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: dados.length,
                    itemBuilder: (context, index) {
                      final item = dados[index];
                      final bool concluido = item["concluido"] == 1;

                      return Card(
                        elevation: concluido ? 0 : 2,
                        color: concluido ? Colors.grey[100] : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        child: ListTile(
                          onTap: () => mostrarDialogoEdicao(context, item),
                          leading: Checkbox(
                            value: concluido,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            onChanged: (val) => alternarStatus(item['id'], item['concluido']),
                          ),
                          title: Text(
                            item["titulo"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: concluido ? TextDecoration.lineThrough : null,
                              color: concluido ? Colors.grey : Colors.indigo[900],
                            ),
                          ),
                          subtitle: Text(
                            "${item["descricao"]}\n📅 ${item["data"]}",
                            style: TextStyle(
                              fontSize: 12,
                              decoration: concluido ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => deletarItem(item["id"]),
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