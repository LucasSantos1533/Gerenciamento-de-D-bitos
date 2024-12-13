import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgdejc/classes/Produtos.dart';

class Venda {
  String id; // ID único da venda
  String funcionarioId; // ID do funcionário que registrou a venda
  String nomeFuncionarioLogado;
  String nomeParticipante;
  List<Produto> produtos; // Lista de produtos vendidos
  String tipo; // "Círculo" ou "Equipe"
  String identificador;
  String? participanteId;
  DateTime data; // Data da venda
  String status;

  Venda({
    required this.id,
    required this.funcionarioId,
    required this.nomeFuncionarioLogado,
    required this.nomeParticipante,
    required this.produtos,
    required this.tipo,
    required this.identificador,
    required this.participanteId,
    required this.data,
    required this.status,
  });

 
  double get total {
  return produtos.fold(
    0,
    (total, produto) {
      print('Produto: ${produto.nome}, Preço: ${produto.preco}, Quantidade: ${produto.quantidade}');
      return total + (produto.preco * produto.quantidade);
    },
  );
}


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'funcionarioId': funcionarioId,
      'nomeFuncionarioLogado':nomeFuncionarioLogado,
      'nomeParticipante': nomeParticipante,
      'produtos': produtos.map((produto) => produto.toMap()).toList(),
      'tipoParticipante': tipo,
      'identificador': identificador,
      'participanteId': participanteId,
      'data': Timestamp.fromDate(data), // Convertendo DateTime para Timestamp
      'total': total, // Incluindo o total no mapa
      'status': status,
    };
  }


  factory Venda.fromMap(Map<String, dynamic> map) {
    return Venda(
      id: map['id'] ?? '',
      funcionarioId: map['funcionarioId'] ?? '',
      nomeFuncionarioLogado: map['nomeFuncionarioLogado'],
      nomeParticipante: map['nomeParticipante'] ?? '',
      produtos: (map['produtos'] as List)
          .map((produtoMap) => Produto.fromMap(produtoMap))
          .toList(),
      tipo: map['tipoParticipante'] ?? '',
      identificador: map['identificador'] ?? '',
      participanteId: map['participanteId'],
      // Convertendo o Timestamp para DateTime
      data: map['data'] is Timestamp
          ? (map['data'] as Timestamp).toDate()
          : DateTime.tryParse(map['data']) ?? DateTime.now(),
      status: map['status'] ?? 'pendente',
    );
  }
}
