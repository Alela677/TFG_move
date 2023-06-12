// ignore_for_file: unused_element

import 'dart:async';
import 'dart:io';
import 'package:move/perfil/utils_perfil/resize_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../../crud/crud_imagen_avatar.dart';
import '../../models/imagen_perfil.dart';
import '../../models/perfil_user.dart';

Future<File> imagenFinal(File? img1) async {
  var complete = Completer<File>();
  File? image;
  if (img1 != null) {
    image = img1;
  } else {
    image = await fileFromImageUrl(
        'http://apimove.somee.com/api/ImagenPerfil/viewimage/default_user.png');
  }
  image = await compressImage(image);
  complete.complete(image);
  return complete.future;
}

Future<File> fileFromImageUrl(String url) async {
  var complete = Completer<File>();
  final response = await http.get(Uri.parse(url));
  final documentDirectory = await getApplicationDocumentsDirectory();
  final file = File(join(documentDirectory.path, 'image.jpg'));
  file.writeAsBytesSync(response.bodyBytes);
  complete.complete(file);
  return complete.future;
}

Future<void> actializarImagenPerfil(PerfilUser perfil, File? imagePick) async {
  await deleteImgPerfil(perfil.id);
  ImagenPerfil(id: 0, imagen: imagePick, idPerfil: perfil.id);
  imagePick = await compressImage(imagePick!);
  await uploadImagePerfil(perfil.id, imagePick);
}
