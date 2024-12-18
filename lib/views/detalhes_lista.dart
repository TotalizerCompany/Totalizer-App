import 'package:flutter/material.dart';
import 'package:totalizer_cell/models/lista.dart';
import 'package:totalizer_cell/services/firestore.dart';

class DetalhesLista extends StatefulWidget {
  final ListaModelo lista;
  final FireStore firestore;

  const DetalhesLista({required this.lista, required this.firestore, super.key});

  @override
  createState() => _DetalhesListaState();
}

class _DetalhesListaState extends State<DetalhesLista> {
  late TextEditingController _tituloController;
  late List<Item> _itens;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.lista.titulo);
    _itens = List.from(widget.lista.itens);

    _tituloController.addListener(() {
      setState(() {});
    });
  }

  void _adicionarItem() {
    TextEditingController itemController = TextEditingController();
    TextEditingController quantidadeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemController,
                decoration: const InputDecoration(labelText: 'Nome do Item'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (itemController.text.isNotEmpty &&
                    quantidadeController.text.isNotEmpty) {
                  setState(() {
                    _itens.add(
                      Item(
                        nome: itemController.text,
                        quantidade:
                            int.tryParse(quantidadeController.text) ?? 1,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _salvarAlteracoes() async {
    // Atualizar os dados no Firestore
    await widget.firestore.atualizarLista(ListaModelo(
      id: widget.lista.id,
      titulo: _tituloController.text,
      itens: _itens,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lista atualizada com sucesso')),
    );

    Navigator.pop(context); // Retorna para a tela anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tituloController.text.isNotEmpty
          ? _tituloController.text
          : 'Detalhes da Lista',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvarAlteracoes,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título da Lista',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _itens.length,
                itemBuilder: (context, index) {
                  var item = _itens[index];
                  return ListTile(
                    title: Text(item.nome),
                    subtitle: Text('Quantidade: ${item.quantidade}'),
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
              onPressed: _adicionarItem,
              child: const Text('Adicionar Item'),
            ),
          ],
        ),
      ),
    );
  }
}
