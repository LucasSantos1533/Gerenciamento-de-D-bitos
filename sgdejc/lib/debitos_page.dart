import 'package:flutter/material.dart';

class DebitosPage extends StatefulWidget {
  @override
  _DebitosPageState createState() => _DebitosPageState();
}

class _DebitosPageState extends State<DebitosPage> {
  final TextEditingController _participanteController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _equipeController = TextEditingController();
  void _addDebito() {
    // Adicionar lógica para salvar o débito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Débito registrado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Débitos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _participanteController,
              decoration: InputDecoration(
                labelText: 'Participante',
              ),
            ),
                TextField(
                  controller: _equipeController,
                  decoration: InputDecoration(labelText: 'Equipe'),
                ),

            SizedBox(height: 16.0), // Espaçamento entre os campos
            TextField(
              controller: _valorController,
              decoration: InputDecoration(
                labelText: 'Valor do Débito',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0), // Espaçamento antes do botão
            ElevatedButton(
              onPressed: _addDebito,
              child: Text('Registrar Débito'),
            ),
          ],
        ),
      ),
    );
  }
}
