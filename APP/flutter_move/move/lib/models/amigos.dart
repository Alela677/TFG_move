class Amigos {
  int solicitante;
  int perfil1;
  int perfil2;

  Amigos(
      {required this.solicitante,
      required this.perfil1,
      required this.perfil2});

  //Devulve un objeto Amigos de un objeto JSON
  factory Amigos.fromJson(Map<String, dynamic> json) {
    return Amigos(
      solicitante: json['solicitante'],
      perfil1: json['perfil1'],
      perfil2: json['perfil2'],
    );
  }
  //Mapea un objeto JSON de un objeto Amigos
  Map toJson() =>
      {'solicitante': solicitante, 'perfil1': perfil1, 'perfil2': perfil2};
}
