import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //cadastrar usurio com email e senha
  Future<String?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha
  }) async {
    try {
      //cria um novo usuario no firebase
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      //atualiza o nome de exibição do usuario com o nome fornecido
      await userCredential.user!.updateDisplayName(nome);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'E-mail já cadatrado';
      }
      return 'Erro desconhecido';
    }
  }

  //logar usuario com emial e senha
  Future<String?> logarUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      //realiza o login do usuario com email e senha
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

  //logout do usuario
  Future<void> deslogarUsuario() async{
    await firebaseAuth.signOut();
  }
}