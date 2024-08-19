import 'package:flutter/material.dart';

class VendasPage extends StatefulWidget {
  @override
  _VendasPageState createState() => _VendasPageState();
}

class _VendasPageState extends State<VendasPage> {
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _participanteController = TextEditingController();
  final _equipeController = TextEditingController(); 
  bool _isCredito = false;

  void _addVenda() {
    // Adicionar lógica para salvar a venda

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Venda Registrada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Vendas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _valorController,
              decoration: InputDecoration(
                labelText: 'Valor da Venda',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0), // Espaçamento entre os campos
            TextField(
              controller: _participanteController,
              decoration: InputDecoration(
                labelText: 'Participante',
              ),
            ),
                  TextField(
                    controller: _equipeController,
                    decoration: InputDecoration(labelText:'Equipe'),
                  ),

           // Espaçamento entre o campo e o checkbox
            Row(
              children: [
                Checkbox(
                  value: _isCredito,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCredito = value ?? false;
                    });
                  },
                ),
                Text('Venda Fiada'),
              ],
            ),
            SizedBox(height: 20.0), // Espaçamento antes do botão
            ElevatedButton(
              onPressed: _addVenda,
              child: Text('Registrar Venda'),
            ),
          ],
        ),
      ),
    );
  }
}
