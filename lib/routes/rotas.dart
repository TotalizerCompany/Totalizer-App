import 'package:flutter/material.dart';
import 'package:totalizer_cell/services/firestore.dart';
import 'package:totalizer_cell/views/recibos.dart';
//import 'package:totalizer_cell/views/qr_code.dart';
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

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Recibos(dados: []),
      //const QRCode(),
      const Lista(),
      const Perfil(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      appBar: AppBar(
        title: const Text('TOTALIZER'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
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
                  backgroundColor: Colors.blue,
                  label: 'Criar nova lista',
                  onPressed: _criarNovaLista,
                ),
                /*SpeedDialChild(
                  child: const Icon(Icons.edit),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  label: 'Segunda ação',
                  onPressed: ,
                ),*/
              ],
              closedForegroundColor: Colors.white,
              openForegroundColor: Colors.black,
              closedBackgroundColor: Colors.blue,
              openBackgroundColor: Colors.blueGrey,
              labelsStyle: const TextStyle(color: Colors.black),
              child: const Icon(Icons.menu),
            )
          : null,
    );
  }
}
