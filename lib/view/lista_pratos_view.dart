import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/usuario_controller.dart';
import 'detalhe_prato_view.dart';

class ListaPratosView extends StatelessWidget {
  const ListaPratosView({super.key});

  @override
  Widget build(BuildContext context) {

    final usuarioController = GetIt.I<UsuarioController>();

    final List<Map<String, String>> pratos = [
      {
        'nome': 'Moqueca de banana',
        'descricao': 'Com arroz integral'
      },
      {
        'nome': 'Feijoada vegana',
        'descricao': 'Com tofu defumado'
      },
      {
        'nome': 'Estrogonofe de grão-de-bico',
        'descricao': 'Com purê de batata'
      },
      {
        'nome': 'Escondidinho de lentilha',
        'descricao': 'Com mandioquinha'
      },
      {
        'nome': 'Lasanha de berinjela',
        'descricao': 'Com arroz à grega'
      },
      {
        'nome': 'Quibe de abóbora',
        'descricao': 'Com tabule de quinoa'
      },
      {
        'nome': 'Yakisoba vegano',
        'descricao': 'Com legumes e arroz jasmine'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pratos'),
      ),

      body: AnimatedBuilder(
        animation: usuarioController,
        builder: (context, _) {

          return ListView.builder(
            itemCount: pratos.length,
            itemBuilder: (context, index) {

              String nomePrato = pratos[index]['nome']!;
              String descricao = pratos[index]['descricao']!;
              bool ehFavorito = usuarioController.favoritos.contains(nomePrato);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.restaurant, color: Colors.green),
                  title: Text(nomePrato),
                  subtitle: Text(descricao),

                  // 👉 CLICAR ABRE DETALHE
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalhePratoView(
                          nome: nomePrato,
                          descricao: descricao,
                        ),
                      ),
                    );
                  },

                  // ⭐ FAVORITOS
                  trailing: IconButton(
                    icon: Icon(
                      ehFavorito ? Icons.star : Icons.star_border,
                      color: ehFavorito ? Colors.orange : null,
                    ),
                    onPressed: () {
                      if (ehFavorito) {
                        usuarioController.removerFavorito(nomePrato);
                      } else {
                        usuarioController.adicionarFavorito(nomePrato);
                      }
                    },
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