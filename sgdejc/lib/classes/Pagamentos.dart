import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgdejc/classes/Produtos.dart';
import 'Participantes.dart';
import 'Debito.dart';
import 'venda.dart';

class Pagamento {
  final String id;
  final String debitoId;
  final String nomeProduto;
  final double valor;
  final int quantidade; 
  final String nomeParticipante;
  final String nomeFuncionario;
  final DateTime dataPagamento;
  final String status;
  final String descricao;
  final String identificador;

  Pagamento({
    required this.id,
    required this.debitoId,
    required this.nomeProduto,
    required this.valor,
    required this.quantidade,
    required this.nomeParticipante,
    required this.nomeFuncionario,
    required this.dataPagamento,
    required this.status,
    required this.descricao,
    required this.identificador,
  });

  factory Pagamento.fromMap(Map<String, dynamic> map, String id) {
    return Pagamento(
      id: id,
      debitoId: map['debitoID'] ?? '',
      nomeProduto: map['nomeProduto'] ?? 'Produto sem nome',
      valor: (map['valor'] as num?)?.toDouble() ?? 0.0,
      quantidade: map['quantidade'] ?? 1,
      nomeParticipante: map['nomeParticipante'] ?? 'Participante desconhecido',
      nomeFuncionario: map['nomeFuncionario'] ?? 'Funcionário não informado',
      dataPagamento: (map['dataPagamento'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'Status desconhecido',
      descricao: map['descricao'] ?? 'Sem descrição',
      identificador: map['identificador'] ?? 'Sem identificador',
    );
  }
}
