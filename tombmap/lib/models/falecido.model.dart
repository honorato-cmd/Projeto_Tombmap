class CadastroFalecidos {
  String? id;
  String? nome;
  String? latitude;
  String? longitude;
  String? lapide;

  CadastroFalecidos({
    this.id,
    this.nome,
    this.latitude,
    this.longitude,
    this.lapide,
  });

  CadastroFalecidos.fromMap(Map<String, dynamic> map) {
    id = id;
    nome = map['nome'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    lapide = map['lapide'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'latitude': latitude,
      'longitude': longitude,
      'lapide': lapide,
    };
  }
}
