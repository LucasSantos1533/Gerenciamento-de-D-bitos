class Funcionarios {
  String id; 
  String nome; 
  String email;
  String telefone;

  Funcionarios({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    // Atribuição padrão para equipe
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email':email,
      'telefone': telefone,
    };
  }

  Funcionarios.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        nome = map['nome'],
        email = map['email'],
        telefone = map['telefone'];
}
