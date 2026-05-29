import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';

import 'controller/usuario_controller.dart';
import 'controller/prato_controller/prato_controller.dart';

import 'view/login_view.dart';
import 'view/cadastro_view.dart';
import 'view/esqueceu_senha_view.dart';
import 'view/home_view.dart';
import 'view/cardapio_view.dart';
import 'view/lista_pratos_view.dart';
import 'view/busca_view.dart';
import 'view/favoritos_view.dart';
import 'view/perfil_view.dart';
import 'view/avaliacoes_view.dart'; // 👈 Importação mapeada da Etapa 2

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final g = GetIt.instance;
  g.registerSingleton<UsuarioController>(UsuarioController());
  g.registerSingleton<PratoController>(PratoController());

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VegMenu',
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      ),
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginView(),
        'cadastro': (context) => const CadastroView(),
        'esqueceu_senha': (context) => const EsqueceuSenhaView(),
        'home': (context) => const HomeView(),
        'cardapio': (context) => const CardapioView(),
        'lista': (context) => const ListaPratosView(),
        'busca': (context) => const BuscaView(),
        'favoritos': (context) => const FavoritosView(),
        'perfil': (context) => const PerfilView(),
        'avaliacoes': (context) => const AvaliacoesView(), // 👈 Rota registrada
      },
    );
  }
}