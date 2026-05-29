import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/prato_controller/prato_controller.dart';
import '../controller/usuario_controller.dart';

class FavoritosView extends StatefulWidget {
  const FavoritosView({super.key});

  @override
  State<FavoritosView> createState() => _FavoritosViewState();
}

class _FavoritosViewState extends State<FavoritosView> {
  final pratoController = GetIt.I<PratoController>();
  final usuarioController = GetIt.I<UsuarioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⭐ Meus Favoritos'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, 'home'); 
          },
        ),
      ),
      body: ListenableBuilder(
        listenable: usuarioController,
        builder: (context, child) {
          // 1. Se a lista de favoritos estiver vazia na memória
          if (usuarioController.favoritos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Você ainda não favoritou nenhum prato. 💔\nVá ao cardápio e clique no coração!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          // 2. Se tiver favoritos, puxamos os pratos do Firebase para pegar o preço e a categoria atualizados
          return StreamBuilder<QuerySnapshot>(
            stream: pratoController.listarPratos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Nenhum prato encontrado.'));
              }

              // 👉 Filtra os documentos do Firebase mantendo apenas os que estão na lista de favoritos
              final todosOsPratos = snapshot.data!.docs;
              final pratosFavoritos = todosOsPratos.where((doc) {
                final dados = doc.data() as Map<String, dynamic>;
                String nome = dados['nome'] ?? '';
                return usuarioController.favoritos.contains(nome);
              }).toList();

              if (pratosFavoritos.isEmpty) {
                return const Center(child: Text('Nenhum prato favoritado.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: pratosFavoritos.length,
                itemBuilder: (context, index) {
                  final dadosDoPrato = pratosFavoritos[index].data() as Map<String, dynamic>;

                  String nome = dadosDoPrato['nome'] ?? 'Sem nome';
                  String categoria = dadosDoPrato['categoria'] ?? 'Geral';
                  double preco = (dadosDoPrato['preco'] ?? 0.0).toDouble();

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.red),
                      title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(categoria.toUpperCase(), style: const TextStyle(fontSize: 12)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'R\$ ${preco.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                usuarioController.removerFavorito(nome);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}