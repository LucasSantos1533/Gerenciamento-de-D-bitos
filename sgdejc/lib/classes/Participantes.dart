class Participantes {
   String id;
  String nome = "";
  late String tipo; // cicrulo ou equipe
  String identificador; // Nomes equipes e circulos

  Participantes({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.identificador,
  });
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'tipo': tipo,
      'identificador': identificador,
    };
  }

  Participantes.fromMap(Map<String, dynamic> map, String documentID)
      : id = documentID,
        nome = map['nome'],
        tipo = map['tipo'],
        identificador = map['identificador'];
}
