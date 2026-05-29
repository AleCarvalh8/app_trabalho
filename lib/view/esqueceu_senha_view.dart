import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/usuario_controller.dart';

class EsqueceuSenhaView extends StatefulWidget {
  const EsqueceuSenhaView({super.key});

  @override
  State<EsqueceuSenhaView> createState() => _EsqueceuSenhaViewState();
}

class _EsqueceuSenhaViewState extends State<EsqueceuSenhaView> {
  final usuarioController = GetIt.I<UsuarioController>();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // 👉 Executa a recuperação conectada ao Firebase com Feedback Visual (RF001)
  Future<void> _recuperarSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      // Chama a função do seu UsuarioController
      await usuarioController.recuperarSenha(_emailController.text.trim());

      if (mounted) {
        // Alerta de Sucesso informativo exigido pelo critério
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail de redefinição enviado! Verifique sua caixa de entrada. 📬'),
            backgroundColor: Colors.green,
          ),
        );
        // Voltar para a tela de login automaticamente após o envio
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        // Alerta de Erro caso o e-mail não exista ou esteja mal digitado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar e-mail: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Insira seu e-mail cadastrado para receber as instruções de redefinição de senha.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Seu E-mail',
                  prefixIcon: Icon(Icons.email, color: Colors.green),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um e-mail válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _carregando
                  ? const Center(child: CircularProgressIndicator(color: Colors.green))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _recuperarSenha, // 👈 Conectado à função acima
                      child: const Text('Enviar E-mail de Recuperação', style: TextStyle(fontSize: 16)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}