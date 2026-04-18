import 'package:flutter/material.dart';

class UsuarioController extends ChangeNotifier {

  String? email;
  String? senha;

  List<String> favoritos = [];

  void cadastrar(String novoEmail, String novaSenha) {
    email = novoEmail;
    senha = novaSenha;
    notifyListeners();
  }

  bool login(String emailDigitado, String senhaDigitada) {
    return email == emailDigitado && senha == senhaDigitada;
  }

  void adicionarFavorito(String prato) {
    if (!favoritos.contains(prato)) {
      favoritos.add(prato);
      notifyListeners();
    }
  }

  void removerFavorito(String prato) {
    favoritos.remove(prato);
    notifyListeners();
  }
}