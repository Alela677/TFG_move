class ImagenPerfil {
  //Propiedades
  int? id;
  dynamic imagen;
  int? idPerfil;

// Constructor
  ImagenPerfil(
      {required this.id, required this.imagen, required this.idPerfil});

//Devulve un objeto ImagenPerfil de un objeto JSON
  factory ImagenPerfil.fromJson(Map<String, dynamic> json) {
    return ImagenPerfil(
      id: json['id'],
      imagen: json['imagen'],
      idPerfil: json['idPerfil'],
    );
  }
}
