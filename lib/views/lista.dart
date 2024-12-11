import 'package:flutter/material.dart';
import 'package:totalizer_cell/models/lista.dart';
import 'package:totalizer_cell/services/firestore.dart';
import 'package:uuid/uuid.dart';

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Map<String, dynamic>> listaCompras = [];
  final FireStore _firestore = FireStore();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder(
              stream: _firestore.conectarStreamListas(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                  return const Center(child: Text('Nenhuma lista disponível.'));
                }

                // Obter os documentos do Firestore
                var documentos = snapshot.data.docs;

                return ListView.builder(
                  itemCount: documentos.length,
                  itemBuilder: (context, index) {
                    var lista = documentos[index].data(); // Obter dados do documento
                    return ListTile(
                      title: Text(lista['titulo'] ?? 'Sem título'),
                      subtitle: Text(
                        'Itens: ${lista['itens'] != null ? lista['itens'].length : 0}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class CriacaoLista extends StatefulWidget {
  final Function(Map<String, dynamic>) onCreate;
  final FireStore firestore;

  CriacaoLista({required this.onCreate, required this.firestore, super.key});

  @override
  _CriacaoListaState createState() => _CriacaoListaState();
}

class _CriacaoListaState extends State<CriacaoLista> {
  final TextEditingController _tituloController = TextEditingController();
  final List<Map<String, dynamic>> _itens = [];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();

  void _adicionarItem() {
    if (_itemController.text.isNotEmpty && _quantidadeController.text.isNotEmpty) {
      setState(() {
        _itens.add({
          'nome': _itemController.text,
          'quantidade': int.tryParse(_quantidadeController.text) ?? 1,
        });
        _itemController.clear();
        _quantidadeController.clear();
      });
    }
  }

  void _criarLista() async {
    if (_tituloController.text.isNotEmpty && _itens.isNotEmpty) {
      var uuid = Uuid();
      String novoId = uuid.v4();

      final novaLista = {
        'titulo': _tituloController.text,
        'itens': _itens,
      };


      // Chama o método de salvar no Firestore
      await widget.firestore.adicionarLista(ListaModelo(
        id: novoId,
        titulo: _tituloController.text,
        itens: _itens.map((item) => Item(nome: item['nome'], quantidade: item['quantidade'])).toList(),
      ));

      widget.onCreate(novaLista);  // Chama a função de criação da lista
      Navigator.pop(context, novaLista);  // Retorna a nova lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Nova Lista')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nome da Lista',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(
                labelText: 'Nome do Item',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _adicionarItem,
              child: const Text('Adicionar Item'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _itens.length,
                itemBuilder: (context, index) {
                  var item = _itens[index];
                  return ListTile(
                    title: Text(item['nome']),
                    subtitle: Text('Quantidade: ${item['quantidade']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _itens.removeAt(index); // Remove o item
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _criarLista,
              child: const Text('Criar Lista'),
            ),
          ],
        ),
      ),
    );
  }
}

