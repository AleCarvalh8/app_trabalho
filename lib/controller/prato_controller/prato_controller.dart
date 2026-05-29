import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PratoController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🍔 Lista todos os pratos (Usado no Cardápio e na Lista)
  Stream<QuerySnapshot> listarPratos() {
    return _firestore.collection('pratos').snapshots();
  }

  // ⭐ Lista apenas os destaques
  Stream<QuerySnapshot> listarDestaques() {
    return _firestore
        .collection('pratos')
        .where('destaque', isEqualTo: true)
        .snapshots();
  }

  // 🔍 FUNÇÃO NOVA: Filtra os pratos pelo que o usuário digitar na busca
  Stream<QuerySnapshot> buscarPratos(String termoBusca) {
    if (termoBusca.isEmpty) {
      // Se não digitou nada, mostra todos os pratos
      return _firestore.collection('pratos').snapshots();
    }
    
    // Busca os pratos cujo nome começa com o texto digitado
    return _firestore
        .collection('pratos')
        .where('nome', isGreaterThanOrEqualTo: termoBusca)
        .where('nome', isLessThanOrEqualTo: '$termoBusca\uf8ff')
        .snapshots();
  }
}