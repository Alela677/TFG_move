class PerfilNombreImagen {
  //Propiedades
  int idPerfil;
  String imagen;
  String nombre;

  //Constructor
  PerfilNombreImagen(
      {required this.idPerfil, required this.imagen, required this.nombre});

  //Devulve un objeto PerfilNombreImagen de un objeto JSON
  factory PerfilNombreImagen.fromJson(Map<String, dynamic> json) {
    return PerfilNombreImagen(
      idPerfil: json['id'],
      imagen: json['imagen'],
      nombre: json['nombre_uno'],
    );
  }
}
