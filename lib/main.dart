import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:device_preview_plus/device_preview_plus.dart';

// TELAS
import 'view/login_view.dart';
import 'view/home_view.dart';
import 'view/cadastro_view.dart';
import 'view/esqueceu_senha_view.dart';
import 'view/sobre_view.dart';
import 'view/lista_pratos_view.dart';
import 'view/cardapio_view.dart';
import 'view/busca_view.dart';
import 'view/favoritos_view.dart';


// CONTROLLER
import 'controller/usuario_controller.dart';

// INSTÂNCIA GLOBAL
final g = GetIt.instance;

void main() {

  // REGISTRA O CONTROLLER
  g.registerSingleton<UsuarioController>(UsuarioController());

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VegMenu',
      debugShowCheckedModeBanner: false,

      // CONFIGURAÇÃO DO MODO CELULAR
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      initialRoute: 'login',

      routes: {
        'login': (context) => const LoginView(),
        'home': (context) => const HomeView(),
        'cadastro': (context) => const CadastroView(),
        'esqueceu': (context) => const EsqueceuSenhaView(),
        'sobre': (context) => const SobreView(),
        'lista': (context) => const ListaPratosView(),
        'cardapio': (context) => const CardapioView(),
        'buscar': (context) => const BuscaView(),
        'favoritos': (context) => const FavoritosView(),
      },
    );
  }
}