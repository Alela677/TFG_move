class Deporte {
  //Propiedades
  int id;
  String nombre;
  String imagen;

//Contructor
  Deporte({required this.id, required this.nombre, required this.imagen});

//Devulve un objeto Deporte de un objeto JSON
  factory Deporte.fromJson(Map<String, dynamic> json) {
    return Deporte(
      id: json['id'],
      nombre: json['nombre'],
      imagen: json['imagen'],
    );
  }
}
