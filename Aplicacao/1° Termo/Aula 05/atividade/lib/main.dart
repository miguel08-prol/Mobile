import 'package:flutter/material.dart';

void main() {
  runApp(const MeuAppContatos());
}

class MeuAppContatos extends StatelessWidget {
  const MeuAppContatos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Contatos Premium',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        colorSchemeSeed: Colors.indigo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: const ListaContatosTela(),
    );
  }
}

// ==========================================
// TELA 1: LISTA DE CONTATOS (AGORA INTERATIVA)
// ==========================================
class ListaContatosTela extends StatefulWidget {
  const ListaContatosTela({super.key});

  @override
  State<ListaContatosTela> createState() => _ListaContatosTelaState();
}

class _ListaContatosTelaState extends State<ListaContatosTela> {
  final List<Map<String, dynamic>> todosContatos = [
    {
      'nome': 'Alice Santos',
      'telefone': '(11) 91111-1111',
      'email': 'alice.santos@email.com',
      'bio': 'Designer UX/UI apaixonada por interfaces limpas.',
      'cor': Colors.purple,
      'icone': Icons.face_4,
      'favorito': true,
    },
    {
      'nome': 'Bruno Silva',
      'telefone': '(21) 92222-2222',
      'email': 'bruno.dev@email.com',
      'bio': 'Desenvolvedor Backend. Não ligar antes das 10h.',
      'cor': Colors.orange,
      'icone': Icons.person,
      'favorito': false,
    },
    {
      'nome': 'Carla Mendes',
      'telefone': '(31) 93333-3333',
      'email': 'carla.marketing@email.com',
      'bio': 'Diretora de Marketing e Estratégia.',
      'cor': Colors.teal,
      'icone': Icons.emoji_emotions,
      'favorito': true,
    },
    {
      'nome': 'Diego Costa',
      'telefone': '(85) 94444-4444',
      'email': 'diego.costa@email.com',
      'bio': 'Fotógrafo freelancer. Sempre em viagens.',
      'cor': Colors.blue,
      'icone': Icons.sentiment_very_satisfied,
      'favorito': false,
    },
  ];

  String queryPesquisa = '';

  @override
  Widget build(BuildContext context) {
    final contatosFiltrados = todosContatos.where((contato) {
      final nomeLower = contato['nome'].toLowerCase();
      final pesquisaLower = queryPesquisa.toLowerCase();
      return nomeLower.contains(pesquisaLower);
    }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('A abrir formulário de novo contacto...')),
          );
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text("Adicionar"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Meus Contactos',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(color: const Color(0xFFF4F6F9)),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      queryPesquisa = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar nome...',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.indigo),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final contato = contatosFiltrados[index];
                
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (_, __, ___) => DetalheContatoTela(contato: contato),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'avatar_${contato['nome']}',
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: contato['cor'].withOpacity(0.15),
                              ),
                              child: Icon(contato['icone'], color: contato['cor'], size: 30),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contato['nome'],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  contato['telefone'],
                                  style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              contato['favorito'] ? Icons.star_rounded : Icons.star_border_rounded,
                              color: contato['favorito'] ? Colors.amber : Colors.grey.shade300,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                contato['favorito'] = !contato['favorito'];
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: contatosFiltrados.length,
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ==========================================
// TELA 2: DETALHES DO CONTATO (PREMIUM UI)
// ==========================================
class DetalheContatoTela extends StatelessWidget {
  final Map<String, dynamic> contato;

  const DetalheContatoTela({super.key, required this.contato});

  @override
  Widget build(BuildContext context) {
    final Color cor = contato['cor'];
    final String nome = contato['nome'];

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: cor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cor.withOpacity(0.7), cor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Hero(
                        tag: 'avatar_$nome',
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
                            ],
                          ),
                          child: Icon(contato['icone'], size: 60, color: cor),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        nome,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Portugal • Mobile",
                        style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AcaoRapida(icon: Icons.call, label: "Ligar", cor: cor, onTap: () => _mostrarAviso(context, "A ligar para $nome...")),
                      _AcaoRapida(icon: Icons.message_rounded, label: "Mensagem", cor: cor, onTap: () => _mostrarAviso(context, "A abrir mensagens...")),
                      _AcaoRapida(icon: Icons.videocam_rounded, label: "Vídeo", cor: cor, onTap: () => _mostrarAviso(context, "A iniciar videochamada...")),
                      _AcaoRapida(icon: Icons.email_rounded, label: "E-mail", cor: cor, onTap: () => _mostrarAviso(context, "A compor e-mail...")),
                    ],
                  ),
                  const SizedBox(height: 35),
                  
                  const Text("Informações do Contacto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      children: [
                        _LinhaDetalhe(icone: Icons.phone_outlined, titulo: "Telemóvel", valor: contato['telefone'], cor: cor),
                        Divider(height: 1, indent: 70, color: Colors.grey.shade200),
                        _LinhaDetalhe(icone: Icons.email_outlined, titulo: "E-mail", valor: contato['email'], cor: cor),
                        Divider(height: 1, indent: 70, color: Colors.grey.shade200),
                        _LinhaDetalhe(icone: Icons.info_outline_rounded, titulo: "Notas", valor: contato['bio'], cor: cor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarAviso(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: const TextStyle(fontWeight: FontWeight.w600)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: contato['cor'].withOpacity(0.9),
      ),
    );
  }
}

// ==========================================
// WIDGETS AUXILIARES PARA LIMPAR O CÓDIGO
// ==========================================

class _AcaoRapida extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color cor;
  final VoidCallback onTap;

  const _AcaoRapida({required this.icon, required this.label, required this.cor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: cor, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
      ],
    );
  }
}

class _LinhaDetalhe extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;
  final Color cor;

  const _LinhaDetalhe({required this.icone, required this.titulo, required this.valor, required this.cor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: cor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icone, color: cor),
      ),
      title: Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(valor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
    );
  }
}