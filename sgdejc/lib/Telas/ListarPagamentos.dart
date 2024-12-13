import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sgdejc/classes/Pagamentos.dart';

class ListarPagamentos extends StatefulWidget {
  @override
  _ListarPagamentosState createState() => _ListarPagamentosState();
}

class _ListarPagamentosState extends State<ListarPagamentos> {
  List<Pagamento> _pagamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPagamentos();
  }

  void _carregarPagamentos() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Pagamentos')
          .orderBy('dataPagamento', descending: true)
          .get();

      for (var doc in snapshot.docs) {
        print("Documento recuperado: ${doc.data()}");
      }
      setState(() {
        _pagamentos = snapshot.docs
            .map((doc) => Pagamento.fromMap(doc.data(), doc.id))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Erro ao carregar pagamentos: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Não foi possível carregar os pagamentos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listar Pagamentos")),
      body: RefreshIndicator(
        onRefresh: () async => _carregarPagamentos(),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _pagamentos.length,
                itemBuilder: (context, index) {
                  final pagamento = _pagamentos[index];
                  // Calcula o total
                  final double total = pagamento.valor * pagamento.quantidade;

                  print(
                      "Valor: ${pagamento.valor}, Quantidade: ${pagamento.quantidade}, Total: $total");

                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                            "Produto: ${pagamento.nomeProduto ?? 'Desconhecido'}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Identificador: ${pagamento.identificador ?? 'N/A'}"),
                            Text(
                                "Valor Total: R\$ ${total.toStringAsFixed(2)}"), // Exibe o valor total
                            Text(
                                "Participante: ${pagamento.nomeParticipante ?? 'N/A'}"),
                            Text(
                                "Funcionário: ${pagamento.nomeFuncionario ?? 'N/A'}"),
                            Text(
                                "Data do Pagamento: ${pagamento.dataPagamento ?? 'N/A'}"),
                            Text("Status: ${pagamento.status ?? 'N/A'}"),
                            Text("Descrição: ${pagamento.descricao ?? 'N/A'}"),
                          ],
                        ),
                        trailing: Icon(Icons.check, color: Colors.green),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
