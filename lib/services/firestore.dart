import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:totalizer_cell/models/lista.dart'; 

class FireStore {
  String userId;

  FireStore() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para adicionar uma nova lista ao Firestore
  Future<void> adicionarLista(ListaModelo listaModelo) async {
    try {
      await _firestore
          .collection(userId) // Nome da coleção é o userId, para armazenar os dados do usuário atual
          .doc('listas')
          .collection('lista_de_compras')
          .doc(listaModelo.id) // ID do documento é o ID da lista
          .set(listaModelo.toMap()); // Converte a lista para um mapa e adiciona ao Firestore
    } catch (e) {
      print("Erro ao adicionar lista: $e");
    }
  }

  // Método para obter um stream de Lista do Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamListas() {
    return _firestore.collection(userId)
                     .doc('listas')
                     .collection('lista_de_compras')
                     .snapshots(); // Retorna um stream dos documentos na coleção do usuário
  }
}
