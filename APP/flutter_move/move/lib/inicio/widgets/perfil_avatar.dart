// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import '../../crud/crud_imagen_avatar.dart';
import '../../models/imagen_perfil.dart';
import '../../models/perfil_user.dart';

// Widget que muestra un CircleAvatar con la imagen de perfil
class PerfilAvatar extends StatefulWidget {
  const PerfilAvatar({super.key, required this.perfil});

  final PerfilUser perfil;

  @override
  State<PerfilAvatar> createState() => _PerfilAvatarState();
}

class _PerfilAvatarState extends State<PerfilAvatar> {
  ImagenPerfil? imgPerfil;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        //Widget que realiza la consulta a la API cuando obtiene respuesta muestra la imagen de perfil
        child: FutureBuilder<ImagenPerfil>(
          future: getImagePerfil(widget.perfil.id),
          builder: (context, snapshot) {
            // si no obtiene respuesta, o esta en proceso muestra un circularprogressindicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              imgPerfil = snapshot.data!;
              return CircleAvatar(
                radius: 90,
                backgroundImage: const NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm6JlUA0_tQCLxrX3aS4WSG6OY4q44Pvs6DwY_cl8KTSxVEtVpamEMOl4roO7Xi4_Xgss&usqp=CAU'),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(imgPerfil!.imagen.toString()),
                  radius: 80,
                ),
              );
            }
          },
        ));
  }
}
