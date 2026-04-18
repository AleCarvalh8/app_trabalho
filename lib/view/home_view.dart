import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VegMenu'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [

            _buildCard(context, 'Cardápio do Dia', Icons.calendar_today, 'cardapio'),
            _buildCard(context, 'Lista de Pratos', Icons.list, 'lista'),
            _buildCard(context, 'Favoritos', Icons.star, 'favoritos'),
            _buildCard(context, 'Buscar', Icons.search, 'buscar'),
            _buildCard(context, 'Sobre', Icons.info, 'sobre'),

          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String titulo, IconData icone, String rota) {
    return GestureDetector(
      onTap: () {

        // ROTAS QUE JÁ EXISTEM
      if (rota == 'lista' || rota == 'sobre' || rota == 'cardapio' || rota == 'buscar' || rota == 'favoritos') {
          Navigator.pushNamed(context, rota);
        } 
        // EM DESENVOLVIMENTO
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$titulo em desenvolvimento'),
            ),
          );
        }

      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 40, color: Colors.green),
            const SizedBox(height: 10),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}