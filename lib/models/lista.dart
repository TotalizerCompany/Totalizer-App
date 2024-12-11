class Item {
  final String nome;
  final int quantidade;

  Item({required this.nome, required this.quantidade});

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'quantidade': quantidade,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      nome: map['nome'],
      quantidade: map['quantidade'],
    );
  }
}

class ListaModelo {
  final String id;
  final String titulo;
  final List<Item> itens;

  ListaModelo({required this.id, required this.titulo, required this.itens});

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'itens': itens.map((item) => item.toMap()).toList(),
    };
  }

  factory ListaModelo.fromMap(Map<String, dynamic> map) {
    return ListaModelo(
      id: map['id'],
      titulo: map['titulo'],
      itens: List<Item>.from(map['itens']?.map((x) => Item.fromMap(x))),
    );
  }
}
