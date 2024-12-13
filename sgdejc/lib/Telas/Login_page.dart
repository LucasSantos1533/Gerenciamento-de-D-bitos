import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgdejc/Servicos/autenticacao_servico.dart';
import 'package:sgdejc/componentes/decoracao_campo_autenticacao.dart';
import 'package:sgdejc/Telas/esqueceuSenha.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool queroLogar = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final AutenticacaoService _autenService = AutenticacaoService();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
    
  }

  // Função para exibir mensagens de erro
  void _showErrorSnackbar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.black),
            const SizedBox(width: 8),
            Expanded(
              child: Text(mensagem, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 6),
      ),
    );
  }

  void sendData() {
    FirebaseFirestore db = FirebaseFirestore.instance;

    //  ID do usuário autenticado
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      db.collection("Funcionarios").doc(user?.uid).set({
        "nome": _nomeController.text,
        "email": _emailController.text,
        "telefone": _telefoneController.text,
      }).then((_) {
        print("Dados do funcionário enviados com sucesso!");
      }).catchError((error) {
        print("Erro ao enviar dados do funcionário: $error");
        _showErrorSnackbar("Erro ao enviar dados do funcionário.");
      });
    } else {
      _showErrorSnackbar("Usuário não autenticado.");
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      if (queroLogar) {
        try {
          UserCredential? userCredential = await _autenService.login(
            email: _emailController.text,
            senha: _senhaController.text,
          );
          if (userCredential?.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        } on AutenticacaoException catch (error) {
          _showErrorSnackbar(error
              .toString());
        } catch (e) {
          _showErrorSnackbar(
              'Ocorreu um erro inesperado. Tente novamente.');
        }
      } else {
        try {
          UserCredential? userCredential = await _autenService.cadastrarUsuario(
            nome: _nomeController.text,
            email: _emailController.text,
            senha: _senhaController.text,
            telefone: _telefoneController.text,
          );
          if (userCredential?.user != null) {
            sendData();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        } on AutenticacaoException catch (error) {
          _showErrorSnackbar(error
              .toString());
        } catch (e) {
          _showErrorSnackbar(
              'Ocorreu um erro inesperado. Tente novamente.'); 
        }
      }
    }
  }

  void _resetarSenha() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EsqueceuSenha()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(235, 230, 233, 241),
      appBar: AppBar(
        title: const Text('Bem-vindo ao SGDejc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "assets/ejclogo.png",
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text(
                  "O importante é a Rosa!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration:
                            getAuthenticationInputDecoration("E-mail").copyWith(
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "O email não pode ser vazio";
                          }
                          if (!value.contains("@")) {
                            return "O email não é válido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _senhaController,
                        decoration:
                            getAuthenticationInputDecoration("Senha").copyWith(
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "A senha não pode ser vazia";
                          }
                          if (value.length < 6) {
                            return "A senha precisa ter no mínimo 6 caracteres";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: queroLogar,
                        child: GestureDetector(
                          onTap: _resetarSenha,
                          child: const Text(
                            "Esqueceu a senha? Clique Aqui",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: !queroLogar,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nomeController,
                              decoration:
                                  getAuthenticationInputDecoration("Nome")
                                      .copyWith(
                                prefixIcon: const Icon(Icons.person),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "O nome não pode ser vazio";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _telefoneController,
                              decoration:
                                  getAuthenticationInputDecoration("Telefone")
                                      .copyWith(
                                prefixIcon: const Icon(Icons.phone_android),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "O telefone não pode ser vazio";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _login,
                        child: Text(queroLogar ? "Login" : "Cadastrar"),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            queroLogar = !queroLogar;
                          });
                        },
                        child: Text(
                          queroLogar
                              ? "Não tem uma conta? Cadastre-se"
                              : "Já tem uma conta? Faça Login",
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
