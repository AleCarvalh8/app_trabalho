import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/prato_controller/prato_controller.dart';
import '../controller/usuario_controller.dart';

class CardapioView extends StatefulWidget {
  const CardapioView({super.key});

  @override
  State<CardapioView> createState() => _CardapioViewState();
}

class _CardapioViewState extends State<CardapioView> {
  final pratoController = GetIt.I<PratoController>();
  final usuarioController = GetIt.I<UsuarioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍔 Nosso Cardápio'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, 'home'); 
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: pratoController.listarPratos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar o cardápio. Tente novamente.'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Nenhum prato disponível no momento. 😔'),
            );
          }

          final listaDePratos = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: listaDePratos.length,
            itemBuilder: (context, index) {
              final dadosDoPrato = listaDePratos[index].data() as Map<String, dynamic>;

              String nome = dadosDoPrato['nome'] ?? 'Sem nome';
              String descricao = dadosDoPrato['descricao'] ?? 'Sem descrição';
              String categoria = dadosDoPrato['categoria'] ?? 'Geral';
              double preco = (dadosDoPrato['preco'] ?? 0.0).toDouble();

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          categoria.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.green.shade800
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        nome,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        descricao,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'R\$ ${preco.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold, 
                              color: Colors.green
                            ),
                          ),
                          ListenableBuilder(
                            listenable: usuarioController,
                            builder: (context, child) {
                              bool jaEhFavorito = usuarioController.favoritos.contains(nome);
                              return IconButton(
                                icon: Icon(
                                  jaEhFavorito ? Icons.favorite : Icons.favorite_border, 
                                  color: Colors.red
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (jaEhFavorito) {
                                      usuarioController.removerFavorito(nome);
                                    } else {
                                      usuarioController.adicionarFavorito(nome);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}