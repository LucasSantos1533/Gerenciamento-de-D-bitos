import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipanteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot?> buscarParticipantePorNome(String nome) async {
    QuerySnapshot query = await _firestore
        .collection('Participantes')
        .where('nome', isEqualTo: nome)
        .limit(1) // Limitar a busca a um resultado
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first; // Retorna o participante se encontrado
    }
    return null;
  }

  Future<String> adicionarNovoParticipante(String nome) async {
    DocumentReference novoParticipante = await _firestore.collection('Participantes').add({
      'nome': nome,
      'dataCriacao': FieldValue.serverTimestamp()
    });
    return novoParticipante.id; // Retorna o ID do novo participante
  }
}
