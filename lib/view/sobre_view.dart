import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [

              Text(
                'Objetivo do Aplicativo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'O aplicativo tem como objetivo apresentar um cardápio vegano, '
                'permitindo ao usuário visualizar pratos, buscar opções e salvar favoritos.',
              ),

              SizedBox(height: 20),

              Text(
                'Equipe de Desenvolvimento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Alexandre Carvalho'),
              SizedBox(height: 20),

              Text(
                'Informações Acadêmicas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Disciplina: Programação para dispositivos Móveis'),
              Text('Instituição: Fatec Ribeirão Preto'),
              Text('Professor: Rodrigo Plotze'),

              SizedBox(height: 20),

              Text(
                'Versão do Aplicativo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Versão 1.0'),
            ],
          ),
        ),
      ),
    );
  }
}