import 'package:flutter/material.dart';
import 'package:totalizer_cell/services/fireauth.dart';
import 'package:totalizer_cell/views/login.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final FireAuth _fireAuth = FireAuth();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _fireAuth.deslogarUsuario();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
        child: const Text("Sair"),
      ),
    );
  }
}
