import 'package:sgdejc/Telas/confirmarpagamento.dart';
import 'package:flutter/material.dart';
import 'package:sgdejc/Servicos/debito_servico.dart';
import 'package:sgdejc/classes/Debito.dart';

class RegistrarPagamento extends StatefulWidget {
  @override
  _RegistrarPagamentoState createState() => _RegistrarPagamentoState();
}

class _RegistrarPagamentoState extends State<RegistrarPagamento> {
  List<Debito> _debitos = [];
  bool _isLoading = true;

  final DebitoServico _debitoServico = DebitoServico();

  @override
  void initState() {
    super.initState();
    _carregarDebitos();
  }

  void _carregarDebitos() async {
    try {
      List<Debito> debitos = await _debitoServico.getDebitos();
      setState(() {
        _debitos = debitos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Erro ao carregar débitos: $e');
      // Exibe um alerta para o usuário
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Ocorreu um erro ao carregar os débitos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Pagamento")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _debitos.length,
              itemBuilder: (context, index) {
                final debito = _debitos[index];
                return ListTile(
                  title: Text(": ${debito.vendaId}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Participante: ${debito.nomeParticipante}"),
                      Text(
                          "Valor Total: R\$ ${debito.valorTotal.toStringAsFixed(2)}"),
                      Text("Funcionário: ${debito.nomeFuncionarioLogado}"),
                    ],
                  ),
                  trailing: debito.status == 'Pago'
                      ? Icon(Icons.check, color: Colors.green)
                      : ElevatedButton(
                          onPressed: debito.status == 'Pago'
                              ? null // Desabilita o botão se o pagamento já foi feito
                              : () async {
                                  final resultado = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ConfirmarPagamento(debito: debito),
                                    ),
                                  );

                                  if (resultado == true) {
                                    // Atualiza a lista de débitos após pagamento
                                    _carregarDebitos();
                                  }
                                },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              debito.status == 'Pago' ? Colors.green : null,
                            ),
                          ),
                          child: Text(debito.status == 'Pago'
                              ? 'Pago'
                              : "Registrar Pagamento"),
                        ),
                );
              },
            ),
    );
  }
}
