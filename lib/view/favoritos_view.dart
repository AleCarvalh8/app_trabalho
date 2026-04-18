import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/usuario_controller.dart';

class FavoritosView extends StatelessWidget {
  const FavoritosView({super.key});

  @override
  Widget build(BuildContext context) {

    final usuarioController = GetIt.I<UsuarioController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),

      body: AnimatedBuilder(
        animation: usuarioController,
        builder: (context, _) {

          if (usuarioController.favoritos.isEmpty) {
            return const Center(
              child: Text('Nenhum favorito ainda'),
            );
          }

          return ListView.builder(
            itemCount: usuarioController.favoritos.length,
            itemBuilder: (context, index) {

              String prato = usuarioController.favoritos[index];

              return ListTile(
                leading: const Icon(Icons.star, color: Colors.orange),
                title: Text(prato),

                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    usuarioController.removerFavorito(prato);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}