// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:move/models/perfil_user.dart';
import '../../crud/crud_imagen_avatar.dart';
import '../../models/imagen_perfil.dart';
import '../../perfil/widgets/imagenes_perfil.dart';
import '../../perfil/widgets/info_perfil.dart';

class VerPerfilAmigo extends StatefulWidget {
  const VerPerfilAmigo({super.key, required this.perfil});

  final PerfilUser perfil;

  @override
  State<VerPerfilAmigo> createState() => _VerPerfilAmigoState();
}

class _VerPerfilAmigoState extends State<VerPerfilAmigo> {
  ImagenPerfil? imgPerfil;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 460),
          child: Container(
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: FutureBuilder<ImagenPerfil>(
                      future: getImagePerfil(widget.perfil.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          imgPerfil = snapshot.data!;
                          return CircleAvatar(
                            radius: 75,
                            backgroundImage: const NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm6JlUA0_tQCLxrX3aS4WSG6OY4q44Pvs6DwY_cl8KTSxVEtVpamEMOl4roO7Xi4_Xgss&usqp=CAU'),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(imgPerfil!.imagen.toString()),
                              radius: 73,
                            ),
                          );
                        }
                      },
                    )),
                InfoPerfil(
                  perfil: widget.perfil,
                ),
              ],
            ),
          )),
      body: ImagenesPerfil(
        perfil: widget.perfil,
        icono: false,
      ),
    );
  }
}
