// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:move/amigos/widgets/display_imagen.dart';
import 'package:move/perfil/widgets/display_image.dart';

import '../../crud/crud_images_perfil.dart';
import '../../models/imagenes.dart';
import '../../models/perfil_user.dart';

class ImagenesPerfil extends StatefulWidget {
  const ImagenesPerfil({super.key, required this.perfil, required this.icono});

  final bool icono;
  final PerfilUser perfil;

  @override
  State<ImagenesPerfil> createState() => _ImagenesPerfilState();
}

class _ImagenesPerfilState extends State<ImagenesPerfil> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: FutureBuilder<List<Imagenes>>(
        future: getImage(widget.perfil.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text("Error al cargar las imágenes.");
          } else if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 60,
                    ),
                    Text('Añade imagenes a tu perfil')
                  ],
                ),
              ),
            );
          } else {
            List<Imagenes> images = snapshot.data!;
            if (images.length <= 0) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo),
                    Text('Añade imagenes a tu perfil'),
                  ],
                ),
              );
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (widget.icono == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DisplayImagePerfil(
                                      imagen: images[index],
                                      perfil: widget.perfil,
                                    )));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DisplayImagenAmigo(imagen: images[index])));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(width: 1.0, color: Colors.grey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          images[index].imagen,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
