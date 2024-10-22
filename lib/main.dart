import 'package:flutter/material.dart';
import 'package:totalizer_cell/tela_inicio.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Totalizer',
      debugShowCheckedModeBanner: false,
      home: TelaInicio(dados: [],),
    );
  }
}