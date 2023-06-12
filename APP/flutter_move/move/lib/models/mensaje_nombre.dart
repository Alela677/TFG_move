class MensajeNombre {
  //Propiedades
  int id;
  int perfil;
  int evento;
  String mensaje;
  String nombrePerfil;

  //Constructor
  MensajeNombre(
      {required this.id,
      required this.perfil,
      required this.evento,
      required this.mensaje,
      required this.nombrePerfil});

//Devulve un objeto MensajeNombre de un objeto JSON
  factory MensajeNombre.fromJson(Map<String, dynamic> json) {
    return MensajeNombre(
        id: json["id"],
        perfil: json["perfil"],
        evento: json["evento"],
        mensaje: json["mensaje"],
        nombrePerfil: json["nombre_uno"]);
  }
}
