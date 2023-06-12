// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../models/imagenes.dart';

// Metodos que recogen las respueta en formato JSON del servidor y guarda la informacion en modelos en la aplicacion

//Metodo que envia la el fichero con la imagen que cargar el usuario y el id de perfil en formato formulario
Future<void> uploadImageUser(int? idUser, File? imagen) async {
  Dio dio = Dio();
  String fileName = imagen!.path.split('/').last;

  FormData image = FormData.fromMap({
    'idPerfilU': idUser,
    'imagen': await MultipartFile.fromFile(
      imagen.path,
      filename: fileName,
    )
  });
  dio.post('https://apimove.somee.com/api/Imagenes/insert', data: image);
}

//Metodo que devuelve en objeto Imagenes por la id del perfil
Future<List<Imagenes>> getImage(int? id) async {
  var completer = Completer<List<Imagenes>>();
  //Respuesta del servidor
  var respuesta = await http
      .get(Uri.parse('https://apimove.somee.com/api/Imagenes/userimages/$id'));
  //Si la repsuesta es correcta leemos la lista de objetos JSON y añadimo el resultado a un objeto ImagenPerfil
  if (respuesta.statusCode == 200) {
    List<Imagenes> img = [];
    var datos = jsonDecode(respuesta.body);
    for (var element in datos) {
      img.add(Imagenes.fromJson(element));
    }
    completer.complete(img);
  }
  return completer.future;
}

//Metodo que eliminar una imagen de la base de datos
Future<void> deleteImagen(int id) async {
  await http
      .delete(Uri.parse('https://apimove.somee.com/api/Imagenes/delete/$id'));
}
