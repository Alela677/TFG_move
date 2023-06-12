// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:move/models/amigos.dart';
import '../models/perfil_completo.dart';
import 'dart:developer' as dev;

// Metodos que recogen las respueta en formato JSON del servidor y guarda la informacion en modelos en la aplicacion

//Metodo que devulve una lista con el nombre de perfil y la imagen asociada
Future<List<PerfilNombreImagen>> getPerfilSugerencias(int id) async {
  var completer = Completer<List<PerfilNombreImagen>>();
  //Respuesta del servidor
  var respuesta = await http
      .get(Uri.parse('https://apimove.somee.com/api/PerfilUser/perfiles/$id'));

  //Si la respuesta es correcta leemos la lista de objetos JSON y lo añadimos a una lista de objetos PerfilNombreImagen
  if (respuesta.statusCode == 200) {
    List<PerfilNombreImagen> perfiles = [];
    var datos = jsonDecode(respuesta.body);
    for (var element in datos) {
      perfiles.add(PerfilNombreImagen.fromJson(element));
    }
    completer.complete(perfiles);
  }
  return completer.future;
}

//Metodo que devulve una lista con el nombre de perfil y la imagen asociada
Future<List<PerfilNombreImagen>> getPerfilAmigos(int id) async {
  var completer = Completer<List<PerfilNombreImagen>>();
  //Respuesta del servidor
  var respuesta = await http
      .get(Uri.parse('https://apimove.somee.com/api/PerfilUser/misamigos/$id'));
  //Si la respuesta es correcta leemos la lista de objetos JSON y lo añadimos a una lista de objetos PerfilNombreImagen
  if (respuesta.statusCode == 200) {
    List<PerfilNombreImagen> perfiles = [];
    var datos = jsonDecode(respuesta.body);
    for (var element in datos) {
      perfiles.add(PerfilNombreImagen.fromJson(element));
    }
    completer.complete(perfiles);
  }
  return completer.future;
}

//Metodo que envia un objeto Amigo en formato JSON para insetar en la base de datos
Future<void> insertAmigo(Amigos amigo) async {
  try {
    await http.post(Uri.parse('https://apimove.somee.com/api/amigos/insert'),
        body: jsonEncode(amigo), headers: {'Content-Type': 'application/json'});
  } catch (e) {
    dev.log(e.toString());
  }
}

//Metodo que elimina un registro de la base de datos amigos
Future<void> deleteAmigo(int perfil, int amigo) async {
  try {
    await http.delete(Uri.parse(
        'https://apimove.somee.com/api/amigos/delete/$perfil/$amigo'));
  } catch (e) {
    dev.log(e.toString());
  }
}
