import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totalizer_cell/services/firestore.dart';
import 'package:totalizer_cell/models/recibos.dart';
import 'package:intl/intl.dart';

class Recibos extends StatefulWidget {
  const Recibos({super.key});

  @override
  createState() => _RecibosState();
}

class _RecibosState extends State<Recibos> {
  late FireStore _fireStore;

  @override
  void initState() {
    super.initState();
    _fireStore = FireStore(); // Inicialize a classe FireStore
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _fireStore.conectarStreamRecibos(), // Conectando ao stream do Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar recibos: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum recibo encontrado.'));
        }

        // Lista de recibos do Firebase
        final recibos = snapshot.data!.docs.map((doc) {
          var reciboData = doc.data();
          return ReciboModelo.fromMap(reciboData); // Converte para o modelo ReciboModelo
        }).toList();

        return ListView.builder(
          itemCount: recibos.length,
          itemBuilder: (context, index) {
            var recibo = recibos[index];

            // Formatando a data para exibir apenas o dia, mês e ano
            String formattedDate = DateFormat('dd/MM/yyyy').format(recibo.timestamp);

            return ListTile(
              title: Text('Recibo: $formattedDate'),  // Exibindo a data formatada
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recibo.itens.map((item) {
                  return Text('${item.nome} - ${item.quantidade}x - R\$ ${item.preco}');
                }).toList(),
              ),
              trailing: Text('Total: R\$ ${recibo.itens.fold(0.0, (total, item) => total + (item.preco * item.quantidade))}'),
            );
          },
        );
      },
    );
  }
}
