import 'package:flutter/material.dart';
import 'vendas_page.dart';
import 'debitos_page.dart';
import 'relatorios_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bem-vindo ao EJC')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: Text('Gerenciar Vendas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VendasPage()),
                );
              },
            ),
            ListTile(
              title: Text('Gerenciar Débitos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RelatoriosPage()),
                );
              },
            ),
            ListTile(
              title: Text('Relatórios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RelatoriosPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Selecione uma opção no menu'),
      ),
    );
  }
}
