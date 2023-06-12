class Usuario {
  //Propiedades
  int? id;
  String? usuario;
  String? password;
  String? email;

  //Constructor
  Usuario(
      {required this.id,
      required this.usuario,
      required this.password,
      required this.email});

  //Devulve un objeto Usuario de un objeto JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      usuario: json['nombre_usuario'],
      password: json['password'],
      email: json['correo_electronico'],
    );
  }

  //Mapea un objeto JSON de un objeto Usuario
  Map toJson() => {
        'id': id,
        'nombre_usuario': usuario,
        'password': password,
        'correo_electronico': email
      };

  void setPassword(String password) {
    this.password = password;
  }
}
