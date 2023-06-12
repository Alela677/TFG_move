// ignore_for_file: library_prefixes

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File?> compressImage(File pickedFile) async {
  var complete = Completer<File>();

  final tempDir = await getTemporaryDirectory();
  final targetPath = '${tempDir.path}/imageee.jpg';

  var result = await FlutterImageCompress.compressAndGetFile(
    pickedFile.path, // Ruta de la imagen seleccionada
    targetPath,
    quality: 60, // Valor de calidad de la imagen comprimida (0-100)
    rotate: 0, // Valor de rotación de la imagen comprimida (0-360)
  );

  File file = File(result!.path);
  complete.complete(file);
  return complete.future; // Devolvemos la imagen comprimida
}
