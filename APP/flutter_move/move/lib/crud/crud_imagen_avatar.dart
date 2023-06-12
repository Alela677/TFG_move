// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../models/imagen_perfil.dart';
// Metodos que recogen las respueta en formato JSON del servidor y guarda la informacion en modelos en la aplicacion

//Metodo que envia la el fichero con la imagen que cargar el usuario y el id de perfil en formato formulario
Future<void> uploadImagePerfil(int? idPerfil, File? imagen) async {
  Dio dio = Dio();
  String fileName = imagen!.path.split('/').last;

  FormData image = FormData.fromMap({
    'imagen': await MultipartFile.fromFile(
      imagen.path,
      filename: fileName,
    ),
    'idPerfil': idPerfil,
  });
  dio.post('https://apimove.somee.com/api/ImagenPerfil/insert', data: image);
}

//Metodo que elimina la imagen de la base de datos
Future<void> deleteImgPerfil(int? id) async {
  await http.delete(
      Uri.parse('https://apimove.somee.com/api/imagenperfil/delete/$id'));
}

//Metodo que devuelve en objeto Imagen la respuesta del servidor
Future<ImagenPerfil> getImagePerfil(int? id) async {
  var complete = Completer<ImagenPerfil>();
  //Respuesta del servidor
  var respuesta = await http.get(
      Uri.parse('https://apimove.somee.com/api/imagenperfil/idPerfil/$id'));
  //Si la respuesta es correcta leemos la lista de objetos JSON y añadimo el resultado a un objeto ImagenPerfil
  if (respuesta.statusCode == 200) {
    ImagenPerfil imgPerfil;
    var datos = jsonDecode(respuesta.body);
    imgPerfil = ImagenPerfil.fromJson(datos[0]);
    complete.complete(imgPerfil);
  }
  return complete.future;
}
