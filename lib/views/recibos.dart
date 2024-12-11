import 'package:flutter/material.dart';

class Recibos extends StatefulWidget {
  final List<dynamic> dados;
  const Recibos({super.key, required this.dados});

  @override
  _RecibosState createState() => _RecibosState();
}

class _RecibosState extends State<Recibos> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.dados.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.dados[index]['nome']),
                    subtitle: Text(widget.dados[index]['preco'].toString()),
                    trailing:
                        Text(widget.dados[index]['quantidade'].toString()),
                  );
                }),
          )
        ],
      ),
    );
  }
}
