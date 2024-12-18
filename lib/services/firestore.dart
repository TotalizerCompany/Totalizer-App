import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:totalizer_cell/models/lista.dart';
import 'package:totalizer_cell/models/recibos.dart';

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
      print("Lista adicionada com sucesso");
    } catch (e) {
      print("Erro ao adicionar lista: $e");
    }
  }

  //Metodo para atualizar uma lista no firestore
  Future<void> atualizarLista(ListaModelo lista) async {
    try {
      await _firestore
          .collection(userId)
          .doc('listas')
          .collection('lista_de_compras')
          .doc(lista.id)
          .update(lista.toMap());
      print("Lista atualizada com sucesso");
    } catch (e) {
      print("Erro ao atualizar lista: $e");
    }
  }

  Future<void> deletarLista(String id) async {
    try {
      await _firestore
          .collection(userId)
          .doc('listas')
          .collection('lista_de_compras')
          .doc(id)
          .delete();
      print("Lista deletada com sucesso");
    } catch (e) {
      print("Erro ao deletar lista: $e");
    }
  }

  // Método para obter um stream de Lista do Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamListas() {
    return _firestore
        .collection(userId)
        .doc('listas')
        .collection('lista_de_compras')
        .snapshots(); // Retorna um stream dos documentos na coleção do usuário
  }

  // Método para adicionar um recibo no Firestore
  Future<void> adicionarRecibo(ReciboModelo reciboModelo) async {
    try {
      await _firestore
          .collection(userId)
          .doc('listas')
          .collection('recibos')
          .add(reciboModelo.toMap());

      print("Recibo adicionado com sucesso");
    } catch (e) {
      print("Erro ao adicionar recibo: $e");
    }
  }

  // Método para obter um stream de recibos do Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamRecibos() {
    return _firestore
        .collection(userId)
        .doc('listas')
        .collection('recibos')
        .snapshots(); // Retorna um stream dos documentos de recibos do usuário
  }
}
