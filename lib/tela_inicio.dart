import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/widgets.dart';
import 'tela_escanear_qr_code.dart';

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
        MaterialPageRoute(builder: (context) => TelaEscanearQrCode()),
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
        title: const Text('Totalizer'),
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color.fromARGB(255, 0, 0, 0),),
            onPressed:() => ('Settings'),
          )
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
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        color: const Color.fromARGB(255, 92, 92, 92),
        activeColor: const Color.fromARGB(255, 0, 0, 0),
        items: const [
          TabItem(icon: Icons.receipt_long, title: 'Recibos'),
          TabItem(icon: Icons.qr_code, title: 'add'),
          TabItem(icon: Icons.checklist, title: 'Lista de Compras'),
        ],
        initialActiveIndex: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}
