// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:move/models/deporte.dart';

// Metodos que recogen las respueta en formato JSON del servidor y guarda la informacion en modelos creado para la aplicacion

//Metodo que devuelve una lista de deportes
Future<List<Deporte>> getDeportes() async {
  var completer = Completer<List<Deporte>>();

  //Respuesta de API a traves del servidor
  var respuesta =
      await http.get(Uri.parse('https://apimove.somee.com/api/Deporte'));

  //Si la respuesta es correcta leemos la lista de objetos JSON y lo añadimos a una lista de objetos Deporte
  if (respuesta.statusCode == 200) {
    List<Deporte> deportes = [];
    var datos = jsonDecode(respuesta.body);
    for (var element in datos) {
      deportes.add(Deporte.fromJson(element));
    }
    completer.complete(deportes);
  }
  return completer.future;
}
