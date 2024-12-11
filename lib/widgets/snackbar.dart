import 'package:flutter/material.dart';

mostrarSnackbar({required BuildContext context, required String mensagem}){
  SnackBar snackBar = SnackBar(
    content: Text(mensagem),
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}