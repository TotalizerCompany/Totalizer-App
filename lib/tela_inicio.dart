import 'package:flutter/material.dart';
import 'tela_escanear_qr_code.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class TelaInicio extends StatefulWidget {
  final List<dynamic> dados;
  const TelaInicio({super.key , required this.dados});

  @override
  createState() => _TelaInicioState();
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
        context,
        MaterialPageRoute(builder: (context) => const TelaEscanearQrCode()),
      );
        break;
      case 2:
        break;
    }
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
        actions: const [
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.dados.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(widget.dados[index]['nome']),
                    subtitle: Text(widget.dados[index]['preco'].toString()),
                    trailing: Text(widget.dados[index]['quantidade'].toString()),
                  );
                }
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.white,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        haptic: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        onTabChange: (index) => _onItemTapped(index),
        tabs: const [
          GButton(
          icon: Icons.receipt_long, 
          text: 'Recibos',
          ),
          GButton(
          icon: Icons.qr_code,
          ),
          GButton(
          icon: Icons.checklist, 
          text: 'Lista',
          ),
        ],
      ),
    );
  }
}
