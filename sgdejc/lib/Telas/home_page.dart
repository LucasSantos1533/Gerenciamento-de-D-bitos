import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sgdejc/Telas/ListarPagamentos.dart';
import 'package:sgdejc/Telas/Login_page.dart';
import 'package:sgdejc/Telas/cadastrarProduto.dart';
import 'package:sgdejc/Telas/registrarVendas.dart';
import 'package:sgdejc/Servicos/debito_servico.dart';
import 'package:sgdejc/Telas/registrar_Pagamento.dart';
import '../relatorios_page.dart';
import '../Telas/consultaDebitos.dart';

class HomePage extends StatelessWidget {
  final DebitoServico debitoServico =
      DebitoServico(); // Instância do serviço de débitos

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, ${user?.email},'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.monetization_on),
              label: Text('Registrar Vendas'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrarVenda()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.list),
              label: Text('Consultar Débitos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Consultadebitos()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.money_off),
              label: Text('Registrar Pagamentos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrarPagamento()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.production_quantity_limits),
              label: Text('Cadastrar Produtos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastrarProduto()),
                );
              },
            ),

            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.production_quantity_limits),
              label: Text('Lista de Pagamentos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListarPagamentos()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.report),
              label: Text('Relatórios'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RelatoriosPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
