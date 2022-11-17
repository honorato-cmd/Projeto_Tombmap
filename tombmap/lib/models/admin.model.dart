class CadastroAdmin {
  String? id;
  String? nome;
  String? cpf;
  String? email;
  String? senha;

  CadastroAdmin({
    this.id,
    this.nome,
    this.cpf,
    this.email,
    this.senha,
  });

  CadastroAdmin.fromMap(Map<String, dynamic> map) {
    id = id;
    nome = map['nome'];
    cpf = map['cpf'];
    email = map['email'];
    senha = map['senha'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'senha': senha,
    };
  }
}
