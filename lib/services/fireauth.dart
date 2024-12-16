import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Cadastrar usuário com email e senha
  Future<String?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      // Cria um novo usuário no Firebase
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Atualiza o nome de exibição do usuário com o nome fornecido
      await userCredential.user!.updateDisplayName(nome);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'E-mail já cadastrado';
      }
      return 'Erro desconhecido';
    }
  }

  // Logar usuário com email e senha
  Future<String?> logarUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      // Realiza o login do usuário com email e senha
      await firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: senha,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return 'E-mail não cadastrado';
      }
      return 'Erro desconhecido';
    }
  }

  // Logout do usuário
  Future<void> deslogarUsuario() async {
    await firebaseAuth.signOut();
  }

  // Corrigido: Get the current user's email
  String? getCurrentUserEmail() {
    final user = firebaseAuth.currentUser;
    return user?.email;
  }
}
