// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import '../models/perfil_completo.dart';
import '../models/perfil_user.dart';
import 'package:http/http.dart' as http;

Future<void> crearPerfil(PerfilUser perfil) async {
  await http.post(Uri.parse('https://apimove.somee.com/api/PerfilUser/insert'),
      body: jsonEncode(perfil), headers: {'Content-Type': 'application/json'});
}

Future<void> editarPeril(PerfilUser perfil) async {
  await http.put(Uri.parse('https://apimove.somee.com/api/PerfilUser/update'),
      body: jsonEncode(perfil), headers: {'Content-Type': 'application/json'});
}

Future<PerfilUser> perfilId(int idPerfil) async {
  var complete = Completer<PerfilUser>();

  var respuesta = await http
      .get(Uri.parse('https://apimove.somee.com/api/PerfilUser/$idPerfil'));

  if (respuesta.statusCode == 200) {
    PerfilUser perfil;
    var datos = jsonDecode(respuesta.body);
    perfil = PerfilUser.fromJson(datos);
    complete.complete(perfil);
  }
  return complete.future;
}

Future<void> elimiarPerfilCompleto(int idPerfil, int idUsuario) async {
  await http.delete(Uri.parse(
      'https://apimove.somee.com/api/PerfilUser/deletePerfil/$idUsuario/$idPerfil'));
}

Future<PerfilUser?> datosPerfil(int? id) async {
  var complete = Completer<PerfilUser?>();
  PerfilUser? perfil;
  final respuesta = await http.get(
      Uri.parse('https://apimove.somee.com/api/PerfilUser/idUser/$id'),
      headers: {"Content-Type": "application/json"});

  if (respuesta.statusCode == 200) {
    if (respuesta.body.isNotEmpty && respuesta.body != '[]') {
      var datos = jsonDecode(respuesta.body)
          as List<dynamic>; // convertir a List<Map<String, dynamic>>
      if (datos.isNotEmpty) {
        // verificar si la lista no está vacía
        perfil = PerfilUser.fromJson(datos[0] as Map<String,
            dynamic>); // convertir el primer elemento de la lista en un objeto PerfilUser
      } else {
        perfil = null;
      }
    } else {
      perfil = null;
    }
  }
  complete.complete(perfil);
  return complete.future;
}

Future<PerfilUser> datosPerfilId(int? id) async {
  var complete = Completer<PerfilUser>();
  PerfilUser? perfilVer;
  final respuesta = await http.get(
      Uri.parse('https://apimove.somee.com/api/PerfilUser/$id'),
      headers: {"Content-Type": "application/json"});

  if (respuesta.statusCode == 200) {
    var datos = jsonDecode(respuesta.body);
    perfilVer = PerfilUser.fromJson(datos);
  }
  complete.complete(perfilVer);
  return complete.future;
}

Future<List<PerfilNombreImagen>> getPerfilSugerencias(int id) async {
  List<PerfilNombreImagen> perfiles = [];
  var complete = Completer<List<PerfilNombreImagen>>();

  var respuesta = await http
      .get(Uri.parse('https://apimove.somee.com/api/PerfilUser/perfiles/$id'));

  if (respuesta.statusCode == 200) {
    var datos = jsonDecode(respuesta.body);
    for (var element in datos) {
      perfiles.add(PerfilNombreImagen.fromJson(element));
    }
  }
  complete.complete(perfiles);
  return complete.future;
}
