class EventoCompleto {
  //Propiedades
  int id;
  String descripcion;
  int numParticipante;
  String fecha;
  String ciudad;
  double latitude;
  double longitude;
  String nombreDeporte;
  String imagen;
  int idDeporte;
  int idPerfil;

  //Constructor
  EventoCompleto(
      {required this.id,
      required this.descripcion,
      required this.numParticipante,
      required this.fecha,
      required this.ciudad,
      required this.longitude,
      required this.latitude,
      required this.imagen,
      required this.nombreDeporte,
      required this.idDeporte,
      required this.idPerfil});

  //Devulve un objeto EventoCompleto de un objeto JSON
  factory EventoCompleto.fromJson(Map<String, dynamic> json) {
    return EventoCompleto(
      id: json['id'],
      descripcion: json['descripcion'],
      numParticipante: json['numero_participantes'],
      idDeporte: json['idDeporte'],
      ciudad: json['ciudad'],
      fecha: json['fecha_evento'],
      longitude: double.parse(json['longitud']),
      latitude: double.parse(json['latitud']),
      nombreDeporte: json['nombre'],
      imagen: json['imagen'],
      idPerfil: json['idPerfil'],
    );
  }
}
