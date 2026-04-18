import 'package:flutter/material.dart';

class EsqueceuSenhaView extends StatefulWidget {
  const EsqueceuSenhaView({super.key});

  @override
  State<EsqueceuSenhaView> createState() => _EsqueceuSenhaViewState();
}

class _EsqueceuSenhaViewState extends State<EsqueceuSenhaView> {

  final emailController = TextEditingController();

  bool emailValido(String email) {
    return email.contains('@') && email.contains('.');
  }

  void recuperarSenha() {

    // CAMPO VAZIO
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o e-mail')),
      );
      return;
    }

    // EMAIL INVÁLIDO
    if (!emailValido(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail inválido')),
      );
      return;
    }

    // SIMULAÇÃO DE ENVIO
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Instruções de recuperação enviadas para o e-mail'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: recuperarSenha,
              child: const Text('Recuperar Senha'),
            ),
          ],
        ),
      ),
    );
  }
}