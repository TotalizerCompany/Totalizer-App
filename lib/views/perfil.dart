import 'package:flutter/material.dart';
import 'package:totalizer_cell/services/fireauth.dart';
import 'package:totalizer_cell/views/login.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final FireAuth _fireAuth = FireAuth();
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserEmail();
  }

  // Fetch current user's email asynchronously
  Future<void> _fetchCurrentUserEmail() async {
    final email = _fireAuth.getCurrentUserEmail();
    setState(() {
      currentUserEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching the email
    if (currentUserEmail == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 100,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              currentUserEmail!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(150, 50),
              ),
              onPressed: () async {
                await _fireAuth.deslogarUsuario(); // Log out the user

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text(
                "Sair",
                style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,)),
            ),
          ],
        ),
      ),
    );
  }
}
