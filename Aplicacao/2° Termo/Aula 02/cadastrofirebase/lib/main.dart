import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TelaAlunos(),
  ));
}

class TelaAlunos extends StatefulWidget {
  const TelaAlunos({super.key});

  @override
  State<TelaAlunos> createState() => _TelaAlunosState();
}

class _TelaAlunosState extends State<TelaAlunos> {
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final cursoController = TextEditingController();

  final CollectionReference alunosRef = FirebaseFirestore.instance.collection('alunos');

  void cadastrarAluno() async {
    String nome = nomeController.text.trim();
    String idadeStr = idadeController.text.trim();
    String curso = cursoController.text.trim();

    if (nome.isEmpty || idadeStr.isEmpty || curso.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    await alunosRef.add({
      'nome': nome,
      'idade': int.tryParse(idadeStr) ?? 0,
      'curso': curso,
    });

    nomeController.clear();
    idadeController.clear();
    cursoController.clear();
  }

  void excluirAluno(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir este aluno?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () {
              alunosRef.doc(id).delete();
              Navigator.pop(ctx);
            },
            child: const Text('EXCLUIR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Alunos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: idadeController, decoration: const InputDecoration(labelText: 'Idade'), keyboardType: TextInputType.number),
            TextField(controller: cursoController, decoration: const InputDecoration(labelText: 'Curso')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: cadastrarAluno, child: const Text('Cadastrar Aluno')),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: alunosRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var aluno = docs[index];
                      return Card(
                        child: ListTile(
                          title: Text(aluno['nome']),
                          subtitle: Text('${aluno['idade']} anos - ${aluno['curso']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => excluirAluno(aluno.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }''
}