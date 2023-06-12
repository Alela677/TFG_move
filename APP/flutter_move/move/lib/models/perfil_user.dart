// ignore_for_file: non_constant_identifier_names

class PerfilUser {
  //Propiedades
  int? id;
  String? nombreUno;
  String? sexo;
  int? edad;
  String? localidad;
  String? descripcion;
  String? deportes;
  int? idUsuario;

  //Constructor
  PerfilUser(
      {required this.id,
      required this.nombreUno,
      required this.sexo,
      required this.edad,
      required this.localidad,
      required this.descripcion,
      required this.deportes,
      required this.idUsuario});

  //Devulve un objeto MensajePerfilUser de un objeto JSON
  factory PerfilUser.fromJson(Map<String, dynamic> json) {
    return PerfilUser(
        id: json['id'],
        nombreUno: json['nombre_uno'],
        sexo: json['sexo'],
        edad: int.parse(json['edad']),
        localidad: json['localidad'],
        descripcion: json['descripcion'],
        deportes: json['deportes'],
        idUsuario: json['idUsuario']);
  }

  //Mapea un objeto JSON de un objeto PerfilUser
  Map toJson() => {
        'id': id,
        'nombre_uno': nombreUno,
        'sexo': sexo,
        'edad': edad,
        'localidad': localidad,
        'descripcion': descripcion,
        'deportes': deportes,
        'idUsuario': idUsuario,
      };
}
