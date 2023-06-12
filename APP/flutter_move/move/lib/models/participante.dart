class Participante {
  //Propiedades
  int id;
  int perfil;
  int evento;

  //Constructor
  Participante({required this.id, required this.perfil, required this.evento});

  //Devulve un objeto Participante de un objeto JSON
  factory Participante.fromJson(Map<String, dynamic> json) {
    return Participante(
        id: json['id'], perfil: json['perfil'], evento: json['evento']);
  }

  //Mapea un objeto JSON de un objeto Participante
  Map toJson() => {
        'id': id,
        'perfil': perfil,
        'evento': evento,
      };
}
