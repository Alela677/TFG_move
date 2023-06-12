class Mensaje {
  // Propiedades
  int id;
  int perfil;
  int evento;
  String mensaje;
  //Constructor
  Mensaje(
      {required this.id,
      required this.perfil,
      required this.evento,
      required this.mensaje});

  //Devulve un objeto Mensaje de un objeto JSON
  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
        id: json["id"],
        perfil: json["perfil"],
        evento: json["evento"],
        mensaje: json["mensaje"]);
  }

  //Mapea un objeto JSON de un objeto Mensaje
  Map toJson() =>
      {'id': id, 'perfil': perfil, 'evento': evento, 'mensaje': mensaje};
}
