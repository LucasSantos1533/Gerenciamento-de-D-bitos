import 'package:flutter/material.dart';
import 'package:sgdejc/classes/Debito.dart';
import 'package:sgdejc/Servicos/debito_servico.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgdejc/classes/Produtos.dart';

class ConfirmarPagamento extends StatefulWidget {
  final Debito debito;

  ConfirmarPagamento({required this.debito});

  @override
  _ConfirmarPagamentoState createState() => _ConfirmarPagamentoState();
}

class _ConfirmarPagamentoState extends State<ConfirmarPagamento> {
  final DebitoServico _debitoServico = DebitoServico();

  Future<void> _registrarPagamentoProduto(int index) async {
    final produto = widget.debito.produtos[index];

    try {
      // Atualiza o estado local imediatamente
      setState(() {
        widget.debito.produtos[index].status = 'Pago';
      });

      // Mostra feedback imediato ao usuário (com base na alteração local)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pagamento registrado para ${produto.nome}!")),
      );

      // Agora, realiza as atualizações no Firestore
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference debitoRef = FirebaseFirestore.instance.collection('Debitos').doc(widget.debito.id);

        // Obtenha o débito atual
        DocumentSnapshot debitoSnapshot = await transaction.get(debitoRef);

        if (!debitoSnapshot.exists) {
          throw Exception("Débito não encontrado!");
        }

        // Atualiza a lista de produtos no Firestore
        List<Map<String, dynamic>> produtosAtualizados = widget.debito.produtos
            .map((p) => p == produto
                ? {
                    ...p.toMap(),
                    'status': 'Pago'
                  } // Atualiza apenas o produto pago
                : p.toMap())
            .toList();

        // Atualiza o débito no Firestore
        transaction.update(debitoRef, {'produtos': produtosAtualizados});

        // Verifica se todos os produtos foram pagos
        if (widget.debito.produtos.every((p) => p.status == 'Pago')) {
          // Se todos os produtos estão pagos, atualiza o débito para "Pago"
          await transaction.update(debitoRef, {'status': 'Pago'});
        }

        // Registra o pagamento na coleção de pagamentos
        await FirebaseFirestore.instance.collection('Pagamentos').add({
          'debitoID': widget.debito.id ?? 'ID não Informado',
          'nomeParticipante': widget.debito.nomeParticipante ?? 'Participante não Informado',
          'nomeFuncionario': widget.debito.nomeFuncionarioLogado ?? 'Funcionário não Informado',
          'nomeProduto': produto.nome ?? 'Produto não Informado',
          'identificador': widget.debito.identificador ?? 'Identificador não informado',
          'valor': produto.preco * (produto.quantidade ?? 1),  // Multiplicando preço pela quantidade
          'descricao': 'Pagamento realizado',
          'dataPagamento': Timestamp.now(),
          'status': 'Pago',
        });
      });

      // Agora, a interface já está atualizada, podemos retornar
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao registrar pagamento: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Confirmar Pagamento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Participante: ${widget.debito.nomeParticipante}"),
            Text("Funcionário: ${widget.debito.nomeFuncionarioLogado}"),
            Text(
                "Valor Total: R\$ ${widget.debito.valorTotal.toStringAsFixed(2)}"),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.debito.produtos.length,
                itemBuilder: (context, index) {
                  final produto = widget.debito.produtos[index];
                  return ListTile(
                    title: Text(produto.nome),
                    subtitle:
                        Text("Valor: R\$ ${produto.preco.toStringAsFixed(2)}"),
                    trailing: produto.status == 'Pago'
                        ? Icon(Icons.check, color: Colors.green)
                        : ElevatedButton(
                            onPressed: () async {
                              await _registrarPagamentoProduto(index);
                            },
                            child: Text("Pagar"),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
