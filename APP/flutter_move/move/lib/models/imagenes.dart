class Imagenes {
  //Porpiedades
  int id;
  int idPerfilU;
  dynamic imagen;
  //Constructor
  Imagenes({required this.id, required this.idPerfilU, this.imagen});

  //Devulve un objeto Imagenes de un objeto JSON
  factory Imagenes.fromJson(Map<String, dynamic> json) {
    return Imagenes(
      id: json['id'],
      idPerfilU: json['idPerfilU'],
      imagen: json['imagen'],
    );
  }
}
