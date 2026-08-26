import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBj9lvwisoTFTyT_0yF67zgykgZKtpJr2U",
      authDomain: "cadastro-de-alunos-8bd51.firebaseapp.com",
      projectId: "cadastro-de-alunos-8bd51",
      storageBucket: "cadastro-de-alunos-8bd51.firebasestorage.app",
      messagingSenderId: "318466879251",
      appId: "1:318466879251:web:084f690c562d203343f4e6",
      measurementId: "G-50HHG4WZCH",
    ),
  );
  
  runApp(const MeuApp());
}

class TitleCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final words = newValue.text.split(' ');
    final capitalized = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');

    return newValue.copyWith(
      text: capitalized,
      selection: TextSelection.collapsed(offset: capitalized.length),
    );
  }
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Painel de Alunos',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E293B),
          primary: const Color(0xFF2563EB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const DashboardAlunos(),
    );
  }
}

class DashboardAlunos extends StatefulWidget {
  const DashboardAlunos({super.key});

  @override
  State<DashboardAlunos> createState() => _DashboardAlunosState();
}

class _DashboardAlunosState extends State<DashboardAlunos> {
  final CollectionReference alunosRef = FirebaseFirestore.instance.collection('alunos');
  String meufiltro = '';

  void _mostrarToast(String mensagem, {bool isErro = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: isErro ? Colors.red : const Color(0xFF2563EB),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _abrirFormulario({String? id, String? nome, int? idade, String? curso}) {
    final isEditing = id != null;
    final nomeCtrl = TextEditingController(text: nome ?? '');
    final idadeCtrl = TextEditingController(text: idade?.toString() ?? '');
    final cursoCtrl = TextEditingController(text: curso ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isEditing ? 'Editar Aluno' : 'Novo Aluno',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeCtrl,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ\s]')),
                  TitleCaseFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: idadeCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  hintText: 'Ex: 22',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cursoCtrl,
                inputFormatters: [
                  TitleCaseFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Curso',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final n = nomeCtrl.text.trim();
              final i = int.tryParse(idadeCtrl.text.trim()) ?? 0;
              final c = cursoCtrl.text.trim();

              if (n.isEmpty) {
                _mostrarToast('Por favor, informe o nome do aluno.', isErro: true);
                return;
              }
              if (i <= 0 || i > 120) {
                _mostrarToast('Informe uma idade válida (entre 1 e 120 anos).', isErro: true);
                return;
              }
              if (c.isEmpty) {
                _mostrarToast('Por favor, informe o curso.', isErro: true);
                return;
              }

              if (isEditing) {
                await alunosRef.doc(id).update({'nome': n, 'idade': i, 'curso': c});
                _mostrarToast('Aluno atualizado com sucesso!');
              } else {
                await alunosRef.add({'nome': n, 'idade': i, 'curso': c});
                _mostrarToast('Aluno cadastrado com sucesso!');
              }
              if (mounted) Navigator.pop(ctx);
            },
            child: Text(isEditing ? 'Salvar' : 'Cadastrar'),
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Aluno'),
        content: const Text('Tem certeza que deseja remover este cadastro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await alunosRef.doc(id).delete();
              if (mounted) Navigator.pop(ctx);
              _mostrarToast('Aluno removido com sucesso!');
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.school, color: Colors.white),
            SizedBox(width: 12),
            Text('Gestão Acadêmica', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Novo Aluno', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: alunosRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Erro ao carregar dados.'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final todosDocs = snapshot.data!.docs;
          final docsFiltrados = todosDocs.where((doc) {
            final dados = doc.data() as Map<String, dynamic>;
            final nome = (dados['nome'] ?? '').toString().toLowerCase();
            return nome.contains(meufiltro.toLowerCase());
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xFFDBEAFE),
                                  child: Icon(Icons.people, color: Color(0xFF2563EB)),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Total de Alunos', style: TextStyle(color: Colors.grey)),
                                    Text(
                                      '${todosDocs.length}',
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isMobile) const SizedBox(height: 12),
                        SizedBox(
                          width: isMobile ? double.infinity : 320,
                          child: TextField(
                            onChanged: (val) => setState(() => meufiltro = val),
                            decoration: InputDecoration(
                              hintText: 'Buscar por nome...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: docsFiltrados.isEmpty
                      ? const Center(child: Text('Nenhum aluno encontrado.'))
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: larguraTela > 1200 ? 4 : (larguraTela > 800 ? 3 : (larguraTela > 600 ? 2 : 1)),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            mainAxisExtent: 140,
                          ),
                          itemCount: docsFiltrados.length,
                          itemBuilder: (context, index) {
                            final doc = docsFiltrados[index];
                            final dados = doc.data() as Map<String, dynamic>;

                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            dados['nome'] ?? '',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                                              onPressed: () => _abrirFormulario(
                                                id: doc.id,
                                                nome: dados['nome'],
                                                idade: dados['idade'],
                                                curso: dados['curso'],
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                              onPressed: () => _confirmarExclusao(doc.id),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Curso: ${dados['curso'] ?? '-'}',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    Chip(
                                      label: Text('${dados['idade'] ?? 0} anos'),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}