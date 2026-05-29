import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:device_preview_plus/device_preview_plus.dart';

// INICIALIZAÇÃO DO FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 

// TELAS (Views)
import 'view/login_view.dart';
import 'view/home_view.dart';
import 'view/cadastro_view.dart';
import 'view/esqueceu_senha_view.dart';
import 'view/sobre_view.dart';
import 'view/lista_pratos_view.dart';
import 'view/cardapio_view.dart';
import 'view/busca_view.dart';
import 'view/favoritos_view.dart';

// CONTROLLERS
import 'controller/usuario_controller.dart';
import 'controller/prato_controller/prato_controller.dart'; // 👈 Import do seu novo controller de pratos

final g = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as chaves configuradas
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // REGISTRO DOS CONTROLADORES NA MEMÓRIA (GetIt)
  g.registerSingleton<UsuarioController>(UsuarioController());
  g.registerSingleton<PratoController>(PratoController()); // 👈 Registro do seu novo controller

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

      // Configuração do DevicePreview
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