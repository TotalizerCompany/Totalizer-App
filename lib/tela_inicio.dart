import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'componentes/qr_code.dart';

class TelaInicio extends StatefulWidget {
  @override
  _TelaInicioState createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QRViewExample()));
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Totalizer'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white,),
            onPressed:() => print('Settings'),
          )
        ],
      ),
      body: const Center(
        child: Text('Totalizer'),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.orange,
        activeColor: Colors.white,
        items: const [
          TabItem(icon: Icons.receipt_long, title: 'Recibos'),
          TabItem(icon: Icons.add, title: 'add'),
          TabItem(icon: Icons.checklist, title: 'Lista de Compras'),
        ],
        initialActiveIndex: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}
