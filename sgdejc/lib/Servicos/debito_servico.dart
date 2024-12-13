import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/Debito.dart';

class DebitoServico {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> conectarStreamDebitos() {
    return _firestore
        .collection('Debitos')
        .snapshots(); // Retorna um Stream<QuerySnapshot>
  }

  Future<QuerySnapshot> consultarDebitosPorId(String participanteId) async {
    return await _firestore
        .collection('Debitos')
        .where('participanteId', isEqualTo: participanteId)
        .get();
  }

  FutureOr<List<Debito>> getDebitos() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('Debitos').get();

      List<Debito> debitos = querySnapshot.docs.map((doc) {
        return Debito.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return debitos;
    } catch (e) {
      print('Erro ao buscar débitos: $e');
      throw Exception('Falha ao buscar débitos');
    }
  }

  Future<void> registrarPagamento(String debitoId) async {
    await _firestore.collection('Debitos').doc(debitoId).update({
      'status': 'Pago',
      'dataPagamento': FieldValue.serverTimestamp(),
    });
  }
}
