import 'package:flutter/material.dart';

class CardapioView extends StatelessWidget {
  const CardapioView({super.key});

  String getCardapioDoDia() {
    int dia = DateTime.now().weekday;

    switch (dia) {
      case 1:
        return 'Moqueca de banana-da-terra com arroz integral';
      case 2:
        return 'Feijoada vegana com tofu defumado e couve';
      case 3:
        return 'Estrogonofe de grão-de-bico com purê de batata';
      case 4:
        return 'Escondidinho de lentilha com purê de mandioquinha';
      case 5:
        return 'Lasanha de berinjela com arroz à grega';
      case 6:
        return 'Quibe de abóbora com tabule de quinoa';
      case 7:
        return 'Yakisoba vegano com legumes e arroz jasmine';
      default:
        return 'Cardápio não disponível';
    }
  }

  String getNomeDia() {
    int dia = DateTime.now().weekday;

    switch (dia) {
      case 1:
        return 'Segunda-feira';
      case 2:
        return 'Terça-feira';
      case 3:
        return 'Quarta-feira';
      case 4:
        return 'Quinta-feira';
      case 5:
        return 'Sexta-feira';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {

    String prato = getCardapioDoDia();
    String dia = getNomeDia();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cardápio do Dia'),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    dia,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Icon(Icons.restaurant_menu,
                      size: 60, color: Colors.green),

                  const SizedBox(height: 20),

                  Text(
                    prato,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}