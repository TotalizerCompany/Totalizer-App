import 'package:flutter/material.dart';
import 'package:totalizer_cell/models/lista.dart';
import 'package:totalizer_cell/services/firestore.dart';
import 'package:uuid/uuid.dart';
import 'detalhes_lista.dart';
class Lista extends StatefulWidget {
  final Function(String) onSelect;
  final Function(String) onDeselect;

  const Lista({required this.onSelect, required this.onDeselect, super.key});

  @override
  createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  final FireStore _firestore = FireStore();
  final Set<String> _listasSelecionadas = {};

  bool get _modoSelecaoAtivo => _listasSelecionadas.isNotEmpty;

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

                // Obter os documentos da subcoleção
                var documentos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documentos.length,
                  itemBuilder: (context, index) {
                    var dados =
                        documentos[index].data() as Map<String, dynamic>;

                    // Converter os dados para um modelo de ListaModelo
                    var lista = ListaModelo.fromMap({
                      'id': documentos[index].id,
                      ...dados,
                    });

                    bool isSelected = _listasSelecionadas.contains(lista.id);

                    return ListTile(
                      title: Text(
                        lista.titulo,
                        style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.black,
                        ),
                      ),
                      subtitle: Text('Itens: ${lista.itens.length}'),
                      tileColor: isSelected ? Color.fromRGBO(0, 0, 255, 0.2) : null,
                      onTap: () {
                        if (_modoSelecaoAtivo) {
                          setState(() {
                            if (isSelected) {
                              _listasSelecionadas.remove(lista.id);
                              widget.onDeselect(lista.id);
                            } else {
                              _listasSelecionadas.add(lista.id);
                              widget.onSelect(lista.id);
                            }
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalhesLista(
                                lista: lista,
                                firestore: _firestore,
                              ),
                            ),
                          );
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          if (!isSelected) {
                            _listasSelecionadas.add(lista.id);
                            widget.onSelect(lista.id);
                          }
                        });
                      },
                      trailing: isSelected
                          ? const Icon(Icons.check_box, color: Colors.blue)
                          : null,
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

  const CriacaoLista(
      {required this.onCreate, required this.firestore, super.key});

  @override
  createState() => _CriacaoListaState();
}

class _CriacaoListaState extends State<CriacaoLista> {
  final TextEditingController _tituloController = TextEditingController();
  final List<Map<String, dynamic>> _itens = [];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();

  void _adicionarItem() {
    if (_itemController.text.isNotEmpty &&
        _quantidadeController.text.isNotEmpty) {
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
      var uuid = const Uuid();
      String novoId = uuid.v4();

      final novaLista = {
        'titulo': _tituloController.text,
        'itens': _itens,
      };

      // Chama o método de salvar no Firestore
      await widget.firestore.adicionarLista(ListaModelo(
        id: novoId,
        titulo: _tituloController.text,
        itens: _itens
            .map((item) =>
                Item(nome: item['nome'], quantidade: item['quantidade']))
            .toList(),
      ));

      widget.onCreate(novaLista); // Chama a função de criação da lista
      Navigator.pop(context, novaLista); // Retorna a nova lista
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
