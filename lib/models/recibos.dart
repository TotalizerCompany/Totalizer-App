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
  late final double total; // Adicionando a propriedade total

  ReciboModelo({
    required this.itens,
    required this.timestamp,
  }) {
    // Calcula o total automaticamente ao criar o objeto
    total = itens.fold(0.0, (sum, item) => sum + (item.preco * item.quantidade));
  }

  Map<String, dynamic> toMap() {
    return {
      'itens': itens.map((item) => item.toMap()).toList(),
      'timestamp': Timestamp.fromDate(timestamp),
      // Não precisa salvar o total pois ele é calculado
    };
  }

  factory ReciboModelo.fromMap(Map<String, dynamic> map) {
    var itensList = (map['itens'] as List)
        .map((itemMap) => Item.fromMap(itemMap as Map<String, dynamic>))
        .toList();

    return ReciboModelo(
      itens: itensList,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}