import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgdejc/classes/Debito.dart';
import 'package:sgdejc/Telas/detalheDebitos.dart';
import 'package:sgdejc/Telas/consultaDebitos.dart';

class Produto {
  String nome;
  double preco;
  int quantidade;
  String status;

  Produto({
    required this.nome,
    required this.preco,
    required this.quantidade,
    required this.status,
  });

 
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'preco': preco,
      'quantidade': quantidade,
      'status': status,
    };
  }

 factory Produto.fromMap(Map<String, dynamic> map) {
  print('Convertendo mapa para Produto: $map'); 
  
  String nome = map['nome'] ?? '';  
  double preco = (map['preco'] ?? 0.0).toDouble(); 
  int quantidade;
  if (map['quantidade'] is int) {
    quantidade = map['quantidade'] as int; 
  } else {
    print('Campo "quantidade" tem valor: ${map['quantidade']}');
    quantidade = int.tryParse(map['quantidade'].toString()) ?? 0; 
  }

  String status = map['status'] ?? 'pendente'; 

  // Log para verificar se a conversão foi feita corretamente
  print('Produto criado: Nome: $nome, Preço: $preco, Quantidade: $quantidade, Status: $status');
  
  return Produto(
    nome: nome,
    preco: preco,
    quantidade: quantidade,
    status: status,
  );
}

}
