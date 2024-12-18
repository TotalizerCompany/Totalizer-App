import 'package:flutter/material.dart';
import 'package:totalizer_cell/services/firestore.dart';
import 'package:totalizer_cell/components/qr_code.dart';
import 'package:totalizer_cell/views/recibos.dart';
import 'package:totalizer_cell/views/lista.dart';
import 'package:totalizer_cell/views/perfil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class Rotas extends StatefulWidget {
  const Rotas({super.key});

  @override
  createState() => _RotasState();
}

class _RotasState extends State<Rotas> {
  int _selectedIndex = 0;
  final FireStore _fireStore = FireStore();
  final Set<String> _listasSelecionadas = {};
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Recibos(),
      Lista(
        onSelect: (id) {
          setState(() {
            _listasSelecionadas.add(id);
          });
        },
        onDeselect: (id) {
          setState(() {
            _listasSelecionadas.remove(id);
          });
        },
      ),
      const Perfil(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar _construirAppBar() {
    if (_selectedIndex == 1 && _listasSelecionadas.isNotEmpty) {
      return AppBar(
        title: Text('${_listasSelecionadas.length} selecionada(s)'),
        leading: IconButton(
          onPressed: () {
            setState(() {
              _listasSelecionadas.clear();
            });
          },
          icon: const Icon(Icons.clear),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_listasSelecionadas.isNotEmpty) {
                for (var id in _listasSelecionadas) {
                  await _fireStore.deletarLista(id);
                }
                setState(() {
                  _listasSelecionadas.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listas excluídas com sucesso')),
                );
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      );
    } else {
      return AppBar(
        title: const Text(
          'TOTALIZER',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: false,
      );
    }
  }

  void _criarNovaLista() async {
    final firestore = FireStore();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriacaoLista(
          onCreate: (novaLista) {},
          firestore: firestore,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _construirAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.white,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        haptic: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        onTabChange: _onItemTapped,
        tabs: const [
          GButton(
            icon: Icons.receipt_long,
            text: 'Recibos',
          ),
          /*GButton(
            icon: Icons.qr_code,
          ),*/
          GButton(
            icon: Icons.checklist,
            text: 'Lista',
          ),
          GButton(
            icon: Icons.person,
            text: 'Perfil',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? SpeedDial(
              speedDialChildren: [
                SpeedDialChild(
                  child: const Icon(Icons.add),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 17, 17, 17),
                  label: 'Criar nova lista',
                  onPressed: _criarNovaLista,
                ),
                SpeedDialChild(
                  child: const Icon(Icons.qr_code),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 17, 17, 17),
                  label: 'Exportar listas',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              QRScanner(useCompactData: false)),
                    );
                  },
                ),
              ],
              closedForegroundColor: const Color.fromARGB(255, 0, 0, 0),
              openForegroundColor: Colors.black,
              closedBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
              openBackgroundColor: const Color.fromARGB(255, 163, 163, 163),
              labelsStyle: const TextStyle(color: Colors.black),
              child: const Icon(Icons.menu),
            )
          : _selectedIndex == 0
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              QRScanner(useCompactData: true)),
                    );
                  },
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  child: const Icon(Icons.qr_code_2),
                )
              : null,
    );
  }
}
