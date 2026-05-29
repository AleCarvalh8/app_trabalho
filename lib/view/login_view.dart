import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/usuario_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Controladores para capturar os textos de e-mail e senha
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  // Injeção do nosso controlador de usuário via GetIt
  final usuarioController = GetIt.I<UsuarioController>();

  // Variável que controla o estado de carregamento (Feedback RF001)
  bool carregando = false;

  void realizarLogin() async {
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    // 1. Validação simples de campos em branco antes de mandar para a internet
    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    // 2. Ativa a tela de carregamento (Feedback visual exigido no RF001)
    setState(() {
      carregando = true;
    });

    try {
      // Chama a função assíncrona do controller que valida na nuvem
      await usuarioController.login(email, senha);
      
      if (mounted) {
        // Se o login deu certo, joga o usuário para a Home e destrói a tela de login da pilha
        Navigator.pushReplacementNamed(context, 'home');
      }
    } catch (erro) {
      // 3. Se o Firebase rejeitar (senha errada, conta bloqueada, etc.), avisa o usuário
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao entrar: E-mail ou senha inválidos.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      // Desativa o carregamento de qualquer forma para liberar a tela
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            // 👉 Se estiver carregando, mostra o spinner de progresso (RF001)
            // Se não, mostra o formulário de login padrão
            child: carregando
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.green),
                        SizedBox(height: 15),
                        Text('Autenticando suas credenciais na nuvem...'),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // Ícone e Logo do VegMenu
                      const Icon(Icons.eco, size: 80, color: Colors.green),
                      const SizedBox(height: 10),
                      const Text(
                        'VegMenu',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),

                      // Campo de E-mail
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Campo de Senha
                      TextField(
                        controller: senhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botão Entrar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: realizarLogin,
                          child: const Text(
                            'Entrar', 
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Links para Criar Conta ou Recuperar Senha
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'cadastro');
                        },
                        child: const Text('Criar conta'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'esqueceu');
                        },
                        child: const Text('Esqueceu a senha?'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}