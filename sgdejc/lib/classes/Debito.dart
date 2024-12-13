import 'package:cloud_firestore/cloud_firestore.dart';
import 'Produtos.dart';

class Debito {
  final String id;
  final String vendaId;
  final String nomeParticipante;
  final String funcionarioId;
  final String nomeFuncionarioLogado;
  final String tipo;
  final String participanteId;
  final String identificador;
  final double valorTotal;
  final String status;
  final DateTime data;
  final List<Produto> produtos;

  Debito({
    required this.id,
    required this.vendaId,
    required this.nomeParticipante,
    required this.funcionarioId,
    required this.nomeFuncionarioLogado,
    required this.tipo,
    required this.participanteId,
    required this.identificador,
    required this.valorTotal,
    required this.status,
    required this.data,
    required this.produtos,
  });

 
 factory Debito.fromMap(Map<String, dynamic> map, String documentId) {
  double valorTotal = 0.0;
  List<dynamic> produtosData = map['produtos'] ?? [];

  for (var produto in produtosData) {
    valorTotal += (produto['preco'] ?? 0) * (produto['quantidade'] ?? 1);
  }


  return Debito(
    id: documentId,
    vendaId: map['vendaId'] ?? '',
    nomeParticipante: map['nomeParticipante'] ?? '',
    funcionarioId: map['funcionarioId'] ?? '',
    nomeFuncionarioLogado: map['nomeFuncionario'] ?? '',
    tipo: map['tipo'] ?? '',
    participanteId: map['participanteId'] ?? '',
    identificador: map['identificador'] ?? '',
    valorTotal: valorTotal, 
    status: map['status'] ?? 'Pendente',
    data: (map['data'] != null)
        ? (map['data'] as Timestamp).toDate()
        : DateTime.now(),
    produtos: produtosData.map((item) => Produto.fromMap(item)).toList(),
  );
}


  Map<String, dynamic> toMap() {
    return {
      'vendaId': vendaId,
      'nomeParticipante': nomeParticipante,
      'funcionarioId': funcionarioId,
      'nomeFuncionario':nomeFuncionarioLogado,
      'tipo': tipo,
      'identificador': identificador,
      'participanteId': participanteId,
      'valorTotal': valorTotal,
      'status': status,
      'data': Timestamp.fromDate(data),
      'produtos': produtos.map((produtos) => produtos.toMap()).toList(),
    };
  }
}
