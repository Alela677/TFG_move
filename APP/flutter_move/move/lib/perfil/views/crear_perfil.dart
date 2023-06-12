// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:move/crud/crud_imagen_avatar.dart';
import 'package:move/crud/crud_perfil_user.dart';
import 'package:move/models/imagen_perfil.dart';
import 'package:move/models/perfil_user.dart';
import '../../global_utils/edades.dart';
import '../../global_utils/localidades.dart';
import '../../global_utils/styleTextForm.dart';
import '../utils_perfil/file_imagen.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:move/inicio/inicio_view.dart';
import 'package:move/models/usuario.dart';
import 'package:move/perfil/widgets/textFieldForm.dart';
import '../../global_utils/validacion_campos.dart';

class CrearPerfil extends StatefulWidget {
  const CrearPerfil({super.key, required this.usuario});

  final Usuario? usuario;

  @override
  State<CrearPerfil> createState() => _CrearPerfilState();
}

class _CrearPerfilState extends State<CrearPerfil> {
  List<int> listEdad = [];
  List<String> listaSexo = ['Hombre', 'Mujer'];
  List<String> localidades = [];

  dynamic imagen;
  File? imagePick;
  int? edad;
  String? sexo;
  String? localidad;
  late String paht;
  PerfilUser? perfilEnviar;
  bool existe = false;
  File? fileImage;
  final controllerUsuario = TextEditingController();
  final controllerDeportes = TextEditingController();
  final controllerDescripcion = TextEditingController();
  ImagenPerfil? imgPerfil;

  Future<File> fileFromImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, 'image.jpg'));
    file.writeAsBytesSync(response.bodyBytes);
    fileImage = file;
    return file;
  }

  @override
  void initState() {
    imagen = const NetworkImage(
        'https://apimove.somee.com/api/ImagenPerfil/viewimage/default_user.png');
    imagePick = null;
    llenarListaEdad(listEdad);
    localidades.addAll(listaLocalidades);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Crea tu perfil',
                style: GoogleFonts.quantico(fontSize: 30))),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondologin.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Container(
              color: Colors.blue.withOpacity(0.9),
              width: double.infinity,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        setState(() {
                          String paht = pickedFile.path;
                          File file = File(paht);
                          imagen = FileImage(file);
                          imagePick = file;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundImage: imagen,
                        backgroundColor: Colors.white,
                        radius: 80,
                      ),
                    ),
                  ),
                ),
                TextFieldFormMove(
                    controller: controllerUsuario,
                    decoration: decoration,
                    titulo: 'Nombre usuario'),
                TextFieldFormMove(
                    controller: controllerDeportes,
                    decoration: decoration,
                    titulo: 'Deportes'),
                TextFieldFormMove(
                    controller: controllerDescripcion,
                    decoration: decoration,
                    titulo: 'Descripción'),
              ]),
            ),
            Container(
              height: 252,
              color: Colors.blue.withOpacity(0.9),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            width: 150,
                            height: 60,
                            child: DropdownButtonFormField(
                              decoration: decoration,
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
                        SizedBox(
                            width: 170,
                            height: 60,
                            child: DropdownButtonFormField(
                              decoration: decoration,
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
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 355,
                    height: 60,
                    child: DropdownButtonFormField(
                      decoration: decoration,
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(350, 40),
                    ),
                    onPressed: () async {
                      perfilEnviar = await datosPerfil(widget.usuario!.id);

                      if (perfilEnviar == null) {
                        PerfilUser perfil = PerfilUser(
                            id: 0,
                            nombreUno: controllerUsuario.text,
                            sexo: sexo,
                            edad: edad,
                            localidad: localidad,
                            descripcion: controllerDescripcion.text,
                            deportes: controllerDeportes.text,
                            idUsuario: widget.usuario!.id);

                        String valido = validaCrearPerfil(perfil);
                        if (valido != 'Valido') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(mensaje(valido));
                        } else {
                          await crearPerfil(perfil);

                          File img;
                          img = await imagenFinal(imagePick);
                          perfilEnviar = await datosPerfil(widget.usuario!.id);
                          await uploadImagePerfil(perfilEnviar!.id, img);

                          await Future.delayed(
                            const Duration(seconds: 5),
                            () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InicioView(
                                      usuario: perfilEnviar!,
                                    ),
                                  ));
                            },
                          );
                        }
                      } else {
                        await getImagePerfil(perfilEnviar!.id);
                        await Future.delayed(
                          const Duration(seconds: 5),
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InicioView(
                                    usuario: perfilEnviar!,
                                  ),
                                ));
                          },
                        );
                      }
                    },
                    child: const Text('Guardar perfil',
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
