import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class RelatoriosPage extends StatelessWidget {
  Future<Map<String, int>> gerarRelatorioProdutosVendidos() async {
    try {
      QuerySnapshot participantesSnapshot =
          await FirebaseFirestore.instance.collection('Participantes').get();

      Map<String, int> contagemProdutos = {};
      print("Contagem de produtos:$contagemProdutos");

      if (participantesSnapshot.docs.isEmpty) {
        print("Nenhum participante encontrado.");
      }

      for (var participanteDoc in participantesSnapshot.docs) {
        // Acessa a subcoleção 'Vendas' de cada participante
        QuerySnapshot vendasSnapshot =
            await participanteDoc.reference.collection('Vendas').get();

        // Itera sobre as vendas e conta as ocorrências dos produtos
        for (var vendaDoc in vendasSnapshot.docs) {
          var venda = vendaDoc.data() as Map<String, dynamic>;

          print("Venda encontrada: $venda");

          if (venda.containsKey('produtos')) {
            List produtosVendidos = venda['produtos'];
            print("Produtos vendidos: $produtosVendidos");

            produtosVendidos.forEach((produto) {
              if (produto is Map && produto.containsKey('nome')) {
                String nomeProduto = produto['nome'];
                if (contagemProdutos.containsKey(nomeProduto)) {
                  contagemProdutos[nomeProduto] =
                      contagemProdutos[nomeProduto]! + 1;
                } else {
                  contagemProdutos[nomeProduto] = 1;
                }
              } else {
                print("Produto com formato inválido: $produto");
              }
            });
          } else {
            print("Nenhum campo 'produtos' encontrado na venda ${vendaDoc.id}");
          }
        }
      }

      print("Relatório gerado com sucesso: $contagemProdutos");
      return contagemProdutos;
    } catch (e) {
      print("Erro ao gerar relatório: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatório de Produtos Vendidos"),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: gerarRelatorioProdutosVendidos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar dados"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum dado encontrado"));
          } else {
            Map<String, int> contagemProdutos = snapshot.data!;

           
            List<PieChartSectionData> pieSections = [];
            contagemProdutos.forEach((produtoNome, quantidadeVendida) {
              pieSections.add(PieChartSectionData(
                title: produtoNome,
                value: quantidadeVendida.toDouble(),
                color: Colors
                    .primaries[pieSections.length % Colors.primaries.length],
                titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ));
            });

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: pieSections,
                  centerSpaceRadius: 60,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(enabled: true),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
