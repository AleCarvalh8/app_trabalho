import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/usuario_controller.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  // Controladores para capturar o que o usuário digita
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  final usuarioController = GetIt.I<UsuarioController>();

  // Variável para controlar o indicador de carregamento na tela (Feedback de progresso)
  bool carregando = false;

  // Função simples para verificar o formato do e-mail
  bool emailValido(String email) {
    return email.contains('@') && email.contains('.');
  }

  // 👉 VALIDAÇÃO DE SENHA FORTE (Critério exigido na Rubrica do RF002)
  bool verificarSenhaForte(String senha) {
    if (senha.length < 6) return false; // Comprimento mínimo de 6 caracteres
    if (!senha.contains(RegExp(r'[A-Z]'))) return false; // Pelo menos uma letra maiúscula
    if (!senha.contains(RegExp(r'[a-z]'))) return false; // Pelo menos uma letra minúscula
    if (!senha.contains(RegExp(r'[0-9]'))) return false; // Pelo menos um número
    if (!senha.contains(RegExp(r'[!@#\$&*~-]'))) return false; // Pelo menos um caractere especial
    return true;
  }

  void executarCadastro() async {
    // 1. Validação de campos vazios
    if (nomeController.text.isEmpty ||
        telefoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        senhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    // 2. Validação do formato do e-mail
    if (!emailValido(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira um endereço de e-mail válido.')),
      );
      return;
    }

    // 3. Validação de segurança da senha (RF002)
    if (!verificarSenhaForte(senhaController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Senha fraca! A senha deve ter no mínimo 6 caracteres, incluir letras maiúsculas, minúsculas, números e um caractere especial (!@#\$&*~-).',
          ),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    // 4. Validação de coincidência de senhas
    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas digitadas não coincidem.')),
      );
      return;
    }

    // Se passou por todas as validações, ativa a tela de carregamento
    setState(() {
      carregando = true;
    });

    try {
      // Envia os dados para o controller fazer a mágica no Firebase
      await usuarioController.cadastrar(
        emailController.text,
        senhaController.text,
        nomeController.text,
        telefoneController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        Navigator.pop(context); // Fecha a tela de cadastro e volta para o Login
      }
    } catch (erro) {
      // Captura o erro retornado pelo Firebase (ex: e-mail já cadastrado) e mostra na tela
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: ${erro.toString()}')),
        );
      }
    } finally {
      // Desativa o indicador de carregamento aconteça o que acontecer
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      // 👉 Se "carregando" for true, mostra o indicador de progresso do Firebase (RF002)
      // Se for false, exibe o formulário normal de cadastro
      body: carregando
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 15),
                  Text('Salvando seus dados na nuvem...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Completo',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: telefoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: confirmarSenhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar Senha',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: executarCadastro,
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}