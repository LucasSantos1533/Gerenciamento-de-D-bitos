import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgdejc/classes/Pagamentos.dart';

class PagamentoServico {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> RegistrarPagamento(Pagamento pagamento) async {
    try {
      await _firestore.collection('pagamentos').add(pagamento.toMap());
      // Atualiza o débito
      DocumentReference debitoRef =
          _firestore.collection('Debitos').doc(pagamento.idDebito);
      await debitoRef.update({
        'valorRestante': FieldValue.increment(-pagamento.valorPago),
      });
    } catch (e) {
      throw Exception('Erro ao registrar pagamento: $e');
    }
  }
}
