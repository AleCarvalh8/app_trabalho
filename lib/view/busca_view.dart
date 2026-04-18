import 'package:flutter/material.dart';

class BuscaView extends StatefulWidget {
  const BuscaView({super.key});

  @override
  State<BuscaView> createState() => _BuscaViewState();
}

class _BuscaViewState extends State<BuscaView> {

  final TextEditingController buscaController = TextEditingController();

  final List<String> pratos = [
    'Moqueca de banana',
    'Feijoada vegana',
    'Estrogonofe de grão-de-bico',
    'Escondidinho de lentilha',
    'Lasanha de berinjela',
    'Quibe de abóbora',
    'Yakisoba vegano'
  ];

  List<String> resultados = [];

  @override
  void initState() {
    super.initState();
    resultados = pratos;
  }

  void filtrar(String texto) {
    setState(() {
      resultados = pratos
          .where((p) =>
              p.toLowerCase().contains(texto.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Pratos'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // CAMPO DE BUSCA
            TextField(
              controller: buscaController,
              onChanged: filtrar,
              decoration: InputDecoration(
                labelText: 'Buscar prato...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // RESULTADOS
            Expanded(
              child: resultados.isEmpty
                  ? const Center(
                      child: Text('Nenhum resultado encontrado'),
                    )
                  : ListView.builder(
                      itemCount: resultados.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.restaurant, color: Colors.green),
                          title: Text(resultados[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}