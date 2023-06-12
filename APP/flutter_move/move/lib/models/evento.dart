class Evento {
  //Propiedades
  int id;
  String descripcion;
  int numParticipante;
  String fecha;
  String ciudad;
  double latitude;
  double longitude;
  int idDeporte;
  int idPerfil;

  //Constructor
  Evento(
      {required this.id,
      required this.descripcion,
      required this.numParticipante,
      required this.fecha,
      required this.ciudad,
      required this.longitude,
      required this.latitude,
      required this.idDeporte,
      required this.idPerfil});

  //Setters
  void setLongitud(double longitud) {
    longitude = longitud;
  }

  void setLatitud(double latitud) {
    latitude = latitud;
  }

  //Devulve un objeto Evento de un objeto JSON
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      descripcion: json['descripcion'],
      numParticipante: json['numero_participantes'],
      fecha: json['fecha_evento'],
      ciudad: json['ciudad'],
      longitude: double.parse(json['longitud']),
      latitude: double.parse(json['latitud']),
      idDeporte: json['idDeporte'],
      idPerfil: json['idPerfilUsuario'],
    );
  }

  //Mapea un objeto JSON de un objeto Evento
  Map toJson() => {
        'id': id,
        'descripcion': descripcion,
        'numero_participante': numParticipante,
        'fecha_evento': fecha,
        'ciudad': ciudad,
        'longitud': longitude,
        'latitud': latitude,
        'idDeporte': idDeporte,
        'idPerfilUsuario': idPerfil
      };
}
