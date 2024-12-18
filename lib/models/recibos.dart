import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String nome;
  final double preco;
  final int quantidade;

  Item({
    required this.nome,
    required this.preco,
    required this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'preco': preco,
      'quantidade': quantidade,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      nome: map['nome'] ?? 'Nome desconhecido',
      preco: map['preco'] ?? 0.0,
      quantidade: map['quantidade'] ?? 0,
    );
  }
}

class ReciboModelo {
  final List<Item> itens;
  final DateTime timestamp;

  ReciboModelo({
    required this.itens,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'itens': itens.map((item) => item.toMap()).toList(),
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory ReciboModelo.fromMap(Map<String, dynamic> map) {
    var itensList = (map['itens'] as List)
        .map((itemMap) => Item.fromMap(itemMap as Map<String, dynamic>))
        .toList();

    return ReciboModelo(
      itens: itensList,
      timestamp: (map['timestamp'] as Timestamp).toDate(), // Converte o timestamp para DateTime
    );
  }
}
