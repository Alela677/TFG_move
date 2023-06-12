// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:move/models/imagenes.dart';
import 'package:move/models/perfil_user.dart';
import 'package:move/perfil/utils_perfil/dialog_eliminar_imagen.dart';

class DisplayImagePerfil extends StatefulWidget {
  const DisplayImagePerfil(
      {super.key, required this.imagen, required this.perfil});

  final PerfilUser perfil;
  final Imagenes imagen;

  @override
  State<DisplayImagePerfil> createState() => _DisplayImagePerfilState();
}

class _DisplayImagePerfilState extends State<DisplayImagePerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 30),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return eliminarImagen(context, widget.imagen, widget.perfil);
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.network(widget.imagen.imagen),
          ),
        ],
      ),
    );
  }
}
