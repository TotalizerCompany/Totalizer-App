import 'package:flutter/material.dart';
import 'package:totalizer_cell/routes/rotas.dart';
import 'package:totalizer_cell/widgets/snackbar.dart';
import 'package:totalizer_cell/views/cadastro.dart';
import 'package:totalizer_cell/services/fireauth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final FireAuth _fireAuth = FireAuth();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Stack(
        children: [
          // Conteúdo principal da tela
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo ou título
                  const Text(
                    'Bem-vindo',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Form(
                    key: _formKeyLogin,
                    child: Column(
                      children: [
                        // Campo de e-mail
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira seu e-mail';
                            }
                            if (value.length < 5 || !value.contains('@')) {
                              return 'Por favor, insira um e-mail válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Campo de senha
                        TextFormField(
                          controller: _senhaController,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira sua senha';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botão de login
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      // Fecha o teclado antes de fazer o login
                      FocusScope.of(context).unfocus();

                      if (_formKeyLogin.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        
                        // Realiza o login
                        String? erro = await _fireAuth.logarUsuario(
                          email: _emailController.text,
                          senha: _senhaController.text,
                        );

                        // Finaliza o loading e exibe a resposta
                        setState(() {
                          _isLoading = false;
                        });

                        if (erro != null) {
                          mostrarSnackbar(
                            context: context, 
                            mensagem: erro,
                          );
                        } else {
                          // Limpa os campos após o login bem-sucedido
                          _emailController.clear();
                          _senhaController.clear();

                          // Navega para a tela de início
                         Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Rotas()),
                          );
                        }
                      }
                    },
                    child: const Text('Entrar'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Ação para recuperação de senha
                        },
                        child: const Text(
                          'Esqueceu sua senha?',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Cadastro()),
                          );
                        },
                        child: const Text(
                          'Cadastre-se!',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Tela de loading, ocupa a tela toda
          _isLoading
            ? Container(
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator()),
              )
            : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

