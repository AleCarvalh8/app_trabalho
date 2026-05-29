import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? usuarioAtual;
  List<String> favoritos = [];

  UsuarioController() {
    // Monitora o estado de login do usuário
    _auth.authStateChanges().listen((User? user) {
      usuarioAtual = user;
      notifyListeners();
    });
  }

  // 👉 CADASTRO DE USUÁRIOS
  Future<void> cadastrar(String email, String senha, String nome, String telefone) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      String uid = credential.user!.uid;

      await _firestore.collection('usuarios').doc(uid).set({
        'uid': uid,
        'nome': nome,
        'telefone': telefone,
        'email': email,
        'data_cadastro': DateTime.now().toIso8601String(),
      });

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // 👉 LOGIN
  Future<void> login(String emailDigitado, String senhaDigitada) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailDigitado,
        password: senhaDigitada,
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // 👉 RECUPERAÇÃO DE SENHA
  Future<void> recuperarSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // 👉 LOGOUT
  Future<void> deslogar() async {
    await _auth.signOut();
    favoritos.clear();
    notifyListeners();
  }

  // 👉 MÉTODOS DE FAVORITOS (LOCAL)
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