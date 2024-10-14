import 'package:flutter/material.dart';
import 'package:totalizer_cell/tela_inicio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Totalizer',
      debugShowCheckedModeBanner: false,
      home: TelaInicio(),
    );
  }
}