import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/usuario_controller.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioController = GetIt.I<UsuarioController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('👤 Meu Perfil'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, 'home'),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: usuarioController.obterPerfilEmTempoReal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Erro ao carregar dados do perfil.'));
          }

          final dados = snapshot.data!.data() as Map<String, dynamic>;
          String nome = dados['nome'] ?? 'Não informado';
          String email = dados['email'] ?? 'Não informado';
          String telefone = dados['telefone'] ?? 'Não informado';

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.badge, color: Colors.green),
                            title: const Text('Nome'),
                            subtitle: Text(nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.email, color: Colors.green),
                            title: const Text('E-mail'),
                            subtitle: Text(email),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.phone, color: Colors.green),
                            title: const Text('Telefone'),
                            subtitle: Text(telefone),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}