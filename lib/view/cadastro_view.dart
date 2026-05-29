import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/usuario_controller.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final usuarioController = GetIt.I<UsuarioController>();
  
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // 👉 RF002: VALIDAÇÃO COMPLEXA DE SEGURANÇA DA SENHA
  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) return 'Digite uma senha.';
    if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
    
    // Regex para verificar Letra Maiúscula, Minúscula e Caractere Especial
    bool temMaiuscula = value.contains(RegExp(r'[A-Z]'));
    bool temMinuscula = value.contains(RegExp(r'[a-z]'));
    bool temEspecial = value.contains(RegExp(r'[!@#\$&*~-%_+=^]'));

    if (!temMaiuscula || !temMinuscula || !temEspecial) {
      return 'A senha precisa de letras maiúsculas, minúsculas e símbolos.';
    }
    return null;
  }

  Future<void> _executarCadastro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      await usuarioController.cadastrar(
        _emailController.text,
        _senhaController.text,
        _nomeController.text,
        _telefoneController.text,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada com sucesso! 🎉'), backgroundColor: Colors.green),
        );
        Navigator.pushReplacementNamed(context, 'home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome Completo', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Informe seu nome.' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(labelText: 'Telefone com DDD', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Informe seu telefone.' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty || !v.contains('@') ? 'Informe um e-mail válido.' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    helperText: 'Mínimo 6 dígitos, com Maiúscula e Símbolo.',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarSenha, // 👈 Aplica a validação forte
                ),
                const SizedBox(height: 20),
                _carregando
                    ? const Center(child: CircularProgressIndicator(color: Colors.green))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        onPressed: _executarCadastro,
                        child: const Text('Cadastrar'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}