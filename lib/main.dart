import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:totalizer_cell/views/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:totalizer_cell/routes/rotas.dart';
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Totalizer',
      debugShowCheckedModeBanner: false,
      home: RoteadorTela(),
    );
  }
}

class RoteadorTela extends StatelessWidget{
  const RoteadorTela({super.key});

  @override
  Widget build (BuildContext context){
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          return const Rotas();
        }else if(snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator(),)
            : const Login();
        }
      },
    );
  }
}