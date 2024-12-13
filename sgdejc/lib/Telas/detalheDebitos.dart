import 'package:flutter/material.dart';
import '../classes/Debito.dart';

class DebitoDetalhes extends StatelessWidget {
  final List<Debito> debitos;

  DebitoDetalhes({required this.debitos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes dos Débitos"),
      ),
      body: ListView(
        children: [
          for (var debito in debitos) ...[
            ListTile(
              title: Text("ID do Débito: ${debito.id}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nome Participante: ${debito.nomeParticipante}"),
                  Text("Nome Funcionário: ${debito.nomeFuncionarioLogado}"),
                  Text("Tipo: ${debito.tipo}"),
                  Text("Identificador: ${debito.identificador}"),
                  Text("Data: ${_formatDate(debito.data)}"),
                  Text("Total: R\$ ${debito.valorTotal.toStringAsFixed(2)}"),
                  if (debito.produtos.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Produtos:"),
                      ...debito.produtos.map((produto) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("- ${produto.nome}: R\$ ${produto.preco.toStringAsFixed(2)}"),
                            Text("  Status: ${produto.status}",
                             style: TextStyle(color: produto.status == 'pago' ? Colors.green : Colors.red)),
                      ],
                        )),
                      ],
                    ),
                ],
              ),
            ),
            Divider(),
          ]
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
