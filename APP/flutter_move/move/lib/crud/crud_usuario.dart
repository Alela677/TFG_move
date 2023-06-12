// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../login/utilsLogin/hash_password.dart';
import '../models/usuario.dart';

Future<void> crearUsuario(Usuario user) async {
  await http.post(Uri.parse('https://apimove.somee.com/api/Usuario/insert'),
      body: jsonEncode(user), headers: {'Content-Type': 'application/json'});
}

Future<void> actualizarUsuario(Usuario user) async {
  await http.put(Uri.parse('https://apimove.somee.com/api/Usuario/update'),
      body: jsonEncode(user), headers: {'Content-Type': 'application/json'});
}

Future<Usuario?> datosUsuario(String usuario, String password) async {
  String pass = hashPassword(password);
  Usuario? user;
  var completer = Completer<Usuario?>();
  final respuesta = await http.get(
    Uri.parse('https://apimove.somee.com/api/Usuario/$usuario/$pass'),
  );

  if (respuesta.statusCode == 200) {
    var datos = jsonDecode(respuesta.body);
    user = Usuario.fromJson(datos);
  } else {
    user = null;
  }
  completer.complete(user);
  return completer.future;
}

Future<Usuario?> compruebaUser(String email) async {
  Usuario? existeUser;
  var completer = Completer<Usuario?>();
  final respuesta = await http.get(
    Uri.parse('https://apimove.somee.com/api/Usuario/comprobar/$email'),
  );
  if (respuesta.statusCode == 200) {
    existeUser = Usuario.fromJson(jsonDecode(respuesta.body));
  } else {
    existeUser = null;
  }
  completer.complete(existeUser);
  return completer.future;
}
