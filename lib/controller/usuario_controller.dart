import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';

class UsuarioController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? usuarioAtual;
  List<String> favoritos = [];
  String dicaDoDia = "Carregando dica saudável para hoje...";

  UsuarioController() {
    _auth.authStateChanges().listen((User? user) {
      usuarioAtual = user;
      if (user != null) {
        buscarDicaDaAPI();
      }
      notifyListeners();
    });
  }

  // 👉 RF007: CONSUMIR API PÚBLICA (Nativa do Dart, sem pacotes extras)
  Future<void> buscarDicaDaAPI() async {
    try {
      final client = HttpClient();
      // API pública gratuita de conselhos (Slip Advice API)
      final request = await client.getUrl(Uri.parse('https://api.adviceslip.com/advice'));
      final response = await request.close();
      
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(responseBody);
        // Traduzindo mentalmente ou pegando o texto direto da API
        dicaDoDia = jsonResponse['slip']['advice'] ?? "Alimente-se bem e viva melhor!";
      }
    } catch (e) {
      dicaDoDia = "Foco na sua saúde: consuma vegetais frescos e beba bastante água!";
    }
    notifyListeners();
  }

  // 👉 RF005: STREAM PARA RECUPERAR DADOS DO PERFIL (2ª COLEÇÃO EM TEMPO REAL)
  Stream<DocumentSnapshot> obterPerfilEmTempoReal() {
    if (usuarioAtual == null) throw Exception("Usuário não logado");
    return _firestore.collection('usuarios').doc(usuarioAtual!.uid).snapshots();
  }

  // MÉTODOS DE AUTENTICAÇÃO JÁ EXISTENTES
  Future<void> cadastrar(String email, String senha, String nome, String telefone) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: senha,
      );
      String uid = credential.user!.uid;
      await _firestore.collection('usuarios').doc(uid).set({
        'uid': uid, 'nome': nome, 'telefone': telefone, 'email': email,
        'data_cadastro': DateTime.now().toIso8601String(),
      });
      notifyListeners();
    } catch (e) { rethrow; }
  }

  Future<void> login(String emailDigitado, String senhaDigitada) async {
    try {
      await _auth.signInWithEmailAndPassword(email: emailDigitado, password: senhaDigitada);
      notifyListeners();
    } catch (e) { rethrow; }
  }

  Future<void> recuperarSenha(String email) async {
    try { await _auth.sendPasswordResetEmail(email: email); } catch (e) { rethrow; }
  }

  Future<void> deslogar() async {
    await _auth.signOut();
    favoritos.clear();
    notifyListeners();
  }

  void adicionarFavorito(String prato) {
    if (!favoritos.contains(prato)) { favoritos.add(prato); notifyListeners(); }
  }

  void removerFavorito(String prato) {
    favoritos.remove(prato); notifyListeners();
  }
}