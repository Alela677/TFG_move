// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, unused_import

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move/crud/crud_imagen_avatar.dart';
import 'package:move/crud/crud_images_perfil.dart';
import 'package:move/models/perfil_user.dart';
import 'package:http/http.dart' as http;
import 'package:move/perfil/utils_perfil/resize_image.dart';
import '../../inicio/inicio_view.dart';
import '../../models/imagen_perfil.dart';
import '../widgets/imagenes_perfil.dart';
import '../widgets/info_perfil.dart';
import 'editar_perfil.dart';

class ViewPerfil extends StatefulWidget {
  const ViewPerfil({super.key, required this.perfil});

  final PerfilUser perfil;

  @override
  State<ViewPerfil> createState() => _ViewPerfilState();
}

class _ViewPerfilState extends State<ViewPerfil> {
  List<String> images = [];
  File? addImagen;
  int _selectedIndex = 0;
  ImagenPerfil? imgPerfil;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 480),
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
                          return const CircularProgressIndicator();
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
                const Spacer(),
                BottomNavigationBar(
                  showSelectedLabels: true,
                  selectedItemColor: Colors.blue,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Inicio',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add_a_photo),
                      label: 'Imagenes',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.edit),
                      label: 'Perfil',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;

                      if (_selectedIndex == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InicioView(
                                usuario: widget.perfil,
                              ),
                            ));
                      } else if (_selectedIndex == 1) {
                        _pickImage();
                      } else if (_selectedIndex == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditaPerfil(
                              perfil: widget.perfil,
                              imgPerfil: imgPerfil!,
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          )),
      body: ImagenesPerfil(
        perfil: widget.perfil,
        icono: true,
      ),
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      setState(() {
        addImagen = File(pickedFile.path);
      });
      addImagen = await compressImage(addImagen!);
      await uploadImageUser(widget.perfil.id, addImagen);
      await Future.delayed(
        const Duration(seconds: 4),
        () {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ViewPerfil(
                perfil: widget.perfil,
              ),
            ),
            (route) => false,
          );
        },
      );
    }
  }
}
