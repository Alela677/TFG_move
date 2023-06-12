// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move/crud/crud_perfil_user.dart';
import 'package:move/models/perfil_user.dart';
import 'package:move/perfil/views/ver_perfil.dart';
import '../../global_utils/edades.dart';
import '../../global_utils/localidades.dart';
import '../../models/imagen_perfil.dart';
import '../utils_perfil/file_imagen.dart';

class EditaPerfil extends StatefulWidget {
  const EditaPerfil({super.key, required this.perfil, required this.imgPerfil});
  final ImagenPerfil? imgPerfil;
  final PerfilUser perfil;
  @override
  State<EditaPerfil> createState() => _EditaPerfilState();
}

class _EditaPerfilState extends State<EditaPerfil> {
  List<int> listEdad = [];
  List<String> listaSexo = ['Hombre', 'Mujer'];
  List<String> localidades = [];

  int? edad;
  String? sexo;
  String? localidad;
  File? fileImage;
  File? imagePick;
  dynamic imageUser;
  PerfilUser? perfilEditado;
  bool _isLoading = false;
  bool visible = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deporteController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  void _startLoading() {
    setState(() {
      _isLoading = true;
      visible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    imagePick = null;
    imageUser = NetworkImage(widget.imgPerfil!.imagen);
    _nameController.text = widget.perfil.nombreUno!;
    _deporteController.text = widget.perfil.deportes!;
    _descripcionController.text = widget.perfil.descripcion!;
    edad = widget.perfil.edad;
    sexo = widget.perfil.sexo;
    localidad = widget.perfil.localidad;

    llenarListaEdad(listEdad);

    localidades.addAll(listaLocalidades);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Editar Perfil', style: GoogleFonts.quantico(fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundImage: imageUser,
                        radius: 50.0,
                      ),
                      onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        final pickedFile =
                            await _picker.getImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          setState(() {
                            String paht = pickedFile.path;
                            File file = File(paht);
                            imagePick = file;
                            imageUser = FileImage(file);
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Nombre de usuario',
                    ),
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            FractionallySizedBox(
              widthFactor: 1.09,
              child: ListTile(
                title: Text(
                  'Deportes',
                  style: GoogleFonts.quantico(fontSize: 20),
                ),
                subtitle: TextFormField(
                  controller: _deporteController,
                  maxLines: 2,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1.09,
              child: ListTile(
                title: Text(
                  'Descripción ',
                  style: GoogleFonts.quantico(fontSize: 20),
                ),
                subtitle: TextFormField(
                  controller: _descripcionController,
                  maxLines: 3,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 170,
                    height: 50,
                    child: DropdownButtonFormField(
                      value: sexo,
                      hint: Text('Sexo',
                          style: GoogleFonts.quantico(fontSize: 20)),
                      items: listaSexo.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          sexo = value;
                        });
                      },
                    )),
                SizedBox(
                    width: 150,
                    height: 50,
                    child: DropdownButtonFormField(
                      value: edad,
                      hint: Text('Edad',
                          style: GoogleFonts.quantico(fontSize: 20)),
                      items: listEdad.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          edad = value;
                        });
                      },
                    )),
              ],
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: 355,
              height: 60,
              child: DropdownButtonFormField(
                value: localidad,
                hint: Text('Localidad',
                    style: GoogleFonts.quantico(fontSize: 20)),
                items: localidades.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    localidad = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: visible,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 40)),
                      ),
                      onPressed: () async {
                        _startLoading();
                        await fileFromImageUrl(widget.imgPerfil!.imagen);
                        if (imagePick != null) {
                          await actializarImagenPerfil(
                              widget.perfil, imagePick);
                        }
                        PerfilUser updatePerfil = PerfilUser(
                            id: widget.perfil.id,
                            nombreUno: _nameController.text,
                            sexo: sexo,
                            edad: edad,
                            localidad: localidad,
                            descripcion: _descripcionController.text,
                            deportes: _deporteController.text,
                            idUsuario: widget.perfil.idUsuario);

                        await editarPeril(updatePerfil);
                        perfilEditado =
                            await datosPerfil(widget.perfil.idUsuario);
                        await Future.delayed(
                          const Duration(seconds: 4),
                          () {
                            setState(() {
                              _isLoading == false;
                            });
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPerfil(
                                  perfil: perfilEditado!,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text('Guardar')),
                ),
                Visibility(
                  visible: visible,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 40)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver')),
                ),
              ],
            ),
            if (_isLoading)
              const CircularProgressIndicator(
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}
