import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvaliacoesView extends StatefulWidget {
  const AvaliacoesView({super.key});

  @override
  State<AvaliacoesView> createState() => _AvaliacoesViewState();
}

class _AvaliacoesViewState extends State<AvaliacoesView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();
  final TextEditingController _pratoController = TextEditingController();

  String? _idAvaliacaoEmEdicao;

  @override
  void dispose() {
    _comentarioController.dispose();
    _notaController.dispose();
    _pratoController.dispose();
    super.dispose();
  }

  // 👉 RF003: INSERÇÃO DE DADOS (Criação de Avaliação e Histórico)
  Future<void> _salvarAvaliacao() async {
    if (_comentarioController.text.isEmpty || _notaController.text.isEmpty || _pratoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!'), backgroundColor: Colors.red),
      );
      return;
    }

    final user = _auth.currentUser;
    if (user == null) return;

    try {
      if (_idAvaliacaoEmEdicao == null) {
        // 1. Grava na Coleção 3: avaliacoes (5 campos)
        await _firestore.collection('avaliacoes').add({
          'usuario_uid': user.uid,
          'usuario_email': user.email,
          'prato_nome': _pratoController.text,
          'comentario': _comentarioController.text,
          'nota': int.tryParse(_notaController.text) ?? 5,
          'data_envio': DateTime.now().toIso8601String(),
        });

        // 2. Grava na Coleção 4: pedidos_historico (Garante as 4 coleções exigidas)
        await _firestore.collection('pedidos_historico').add({
          'cliente_uid': user.uid,
          'item_nome': _pratoController.text,
          'tipo_registro': 'Feedback Enviado',
          'status': 'Concluído',
          'data_registro': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avaliação enviada com sucesso! 🎉'), backgroundColor: Colors.green),
        );
      } else {
        // 👉 RF004: ATUALIZAÇÃO DE DADOS (Edição)
        await _firestore.collection('avaliacoes').doc(_idAvaliacaoEmEdicao).update({
          'prato_nome': _pratoController.text,
          'comentario': _comentarioController.text,
          'nota': int.tryParse(_notaController.text) ?? 5,
          'ultima_atualizacao': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avaliação atualizada com sucesso! 🔄'), backgroundColor: Colors.blue),
        );
        _idAvaliacaoEmEdicao = null;
      }

      // Limpa os campos após salvar
      _comentarioController.clear();
      _notaController.clear();
      _pratoController.clear();
      setState(() {});

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro na operação: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Função para Deletar (Bônus para o CRUD ficar perfeito)
  Future<void> _deletarAvaliacao(String id) async {
    await _firestore.collection('avaliacoes').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Avaliação removida!'), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('💬 Avaliar Pratos'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, 'home'),
        ),
      ),
      body: Column(
        children: [
          // Formulário de Entrada
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      _idAvaliacaoEmEdicao == null ? 'Deixe seu Feedback' : 'Editar Avaliação',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _pratoController,
                      decoration: const InputDecoration(labelText: 'Nome do Prato', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _comentarioController,
                      decoration: const InputDecoration(labelText: 'Seu Comentário', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Nota (1 a 5)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      onPressed: _salvarAvaliacao,
                      child: Text(_idAvaliacaoEmEdicao == null ? 'Enviar Avaliação' : 'Salvar Alterações'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Text('Feed de Comentários em Tempo Real', style: TextStyle(fontWeight: FontWeight.bold)),
          
          // Lista de Comentários do Firebase
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('avaliacoes').orderBy('data_envio', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhuma avaliação ainda. Seja o primeiro!'));
                }

                final listaDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: listaDocs.length,
                  itemBuilder: (context, index) {
                    final dados = listaDocs[index].data() as Map<String, dynamic>;
                    String idDoc = listaDocs[index].id;
                    String prato = dados['prato_nome'] ?? '';
                    String comentario = dados['comentario'] ?? '';
                    int nota = dados['nota'] ?? 5;
                    String autorUid = dados['usuario_uid'] ?? '';

                    bool ehMeuComentario = user != null && user.uid == autorUid;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Text('⭐$nota', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(prato, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(comentario),
                        trailing: ehMeuComentario
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        _idAvaliacaoEmEdicao = idDoc;
                                        _pratoController.text = prato;
                                        _comentarioController.text = comentario;
                                        _notaController.text = nota.toString();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deletarAvaliacao(idDoc),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}