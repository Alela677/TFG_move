// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:move/crud/crud_images_perfil.dart';
import 'package:move/models/imagenes.dart';
import 'package:move/models/perfil_user.dart';
import 'package:move/perfil/views/ver_perfil.dart';

AlertDialog eliminarImagen(
    BuildContext context, Imagenes imagen, PerfilUser perfil) {
  var alert = AlertDialog(
    title: const Text('Eliminar imagen'),
    content: const SingleChildScrollView(
      child: ListBody(
        children: [
          Text('¿Seguro que quiere eliminar la imagen?'),
        ],
      ),
    ),
    actions: [
      TextButton(
          onPressed: () async {
            await deleteImagen(imagen.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPerfil(perfil: perfil),
                ));
          },
          child: const Text('Aceptar')),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar')),
    ],
  );

  return alert;
}
