import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/prato_controller/prato_controller.dart';

class ListaPratosView extends StatefulWidget {
  const ListaPratosView({super.key});

  @override
  State<ListaPratosView> createState() => _ListaPratosViewState();
}

class _ListaPratosViewState extends State<ListaPratosView> {
  final pratoController = GetIt.I<PratoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Lista de Pratos'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Garante o retorno explícito para a Home sem esvaziar a pilha
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
              child: Text('Erro ao carregar a lista.'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Nenhum prato cadastrado no Firebase.'),
            );
          }

          final listaDePratos = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: listaDePratos.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final dadosDoPrato = listaDePratos[index].data() as Map<String, dynamic>;

              String nome = dadosDoPrato['nome'] ?? 'Sem nome';
              String categoria = dadosDoPrato['categoria'] ?? 'Geral';
              double preco = (dadosDoPrato['preco'] ?? 0.0).toDouble();

              return ListTile(
                leading: const Icon(Icons.restaurant_menu, color: Colors.green),
                title: Text(
                  nome,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(categoria.toUpperCase(), style: const TextStyle(fontSize: 12)),
                trailing: Text(
                  'R\$ ${preco.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}