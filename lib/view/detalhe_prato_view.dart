import 'package:flutter/material.dart';

class DetalhePratoView extends StatelessWidget {
  final String nome;
  final String descricao;

  const DetalhePratoView({
    super.key,
    required this.nome,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.restaurant_menu, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              nome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(descricao),
          ],
        ),
      ),
    );
  }
}