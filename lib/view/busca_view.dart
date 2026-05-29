import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/prato_controller/prato_controller.dart';

class BuscaView extends StatefulWidget {
  const BuscaView({super.key});

  @override
  State<BuscaView> createState() => _BuscaViewState();
}

class _BuscaViewState extends State<BuscaView> {
  final pratoController = GetIt.I<PratoController>();
  final TextEditingController _buscaController = TextEditingController();
  
  String _textoBusca = "";
  String _criterioOrdenacao = "nome"; // 👈 Estado para armazenar o critério (nome ou preco)

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Buscar Pratos'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, 'home'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                labelText: 'Digite o nome do prato...',
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                suffixIcon: _textoBusca.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _buscaController.clear();
                            _textoBusca = "";
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (text) => setState(() => _textoBusca = text),
            ),
          ),

          // 👉 RF006: SELETOR VISUAL PARA ORDENAR OS RESULTADOS DA PESQUISA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ordenar por:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _criterioOrdenacao,
                  items: const [
                    DropdownMenuItem(value: "nome", child: Text("Ordem Alfabética (A-Z)")),
                    DropdownMenuItem(value: "preco", child: Text("Menor Preço")),
                  ],
                  onChanged: (String? novoValor) {
                    if (novoValor != null) {
                      setState(() => _criterioOrdenacao = novoValor);
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: pratoController.buscarPratos(_textoBusca),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.green));
                }
                if (snapshot.hasError) return const Center(child: Text('Erro ao realizar a busca.'));
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhum prato encontrado. 😔'));
                }

                // Pega os documentos originais do Firebase
                List<DocumentSnapshot> pratos = snapshot.data!.docs;

                // 👉 Executa a ordenação na lista local de acordo com o critério escolhido
                if (_criterioOrdenacao == "nome") {
                  pratos.sort((a, b) => (a['nome'] ?? '').toString().compareTo((b['nome'] ?? '').toString()));
                } else if (_criterioOrdenacao == "preco") {
                  pratos.sort((a, b) => (a['preco'] ?? 0).compareTo(b['preco'] ?? 0));
                }

                return ListView.builder(
                  itemCount: pratos.length,
                  itemBuilder: (context, index) {
                    final dados = pratos[index].data() as Map<String, dynamic>;
                    String nome = dados['nome'] ?? 'Sem nome';
                    String categoria = dados['categoria'] ?? 'Geral';
                    double preco = (dados['preco'] ?? 0.0).toDouble();

                    return ListTile(
                      leading: const Icon(Icons.fastfood, color: Colors.green),
                      title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(categoria),
                      trailing: Text(
                        'R\$ ${preco.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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