// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/amigos/views/mis_amigos.dart';
import 'package:move/crud/crud_amigos.dart';
import '../../crud/crud_perfil_user.dart';
import '../../models/perfil_completo.dart';
import '../../models/perfil_user.dart';
import '../utils_amigos.dart/alert_dialog.dart';
import '../views/ver_perfil_amigo.dart';

class Amigos extends StatefulWidget {
  const Amigos({super.key, required this.perfil});

  final PerfilUser perfil;

  @override
  State<Amigos> createState() => _AmigosState();
}

class _AmigosState extends State<Amigos> {
  PerfilUser? perfilVer;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPerfilAmigos(widget.perfil.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          List<PerfilNombreImagen> perfiles = snapshot.data!;
          // ignore: prefer_is_empty
          if (perfiles.length <= 0) {
            return Center(
              child: SizedBox(
                child: Text(
                  'Añade amigos a tu lista',
                  style: GoogleFonts.quantico(fontSize: 17),
                ),
              ),
            );
          } else {
            return SizedBox(
              height: 550,
              width: double.infinity,
              child: ListView.builder(
                itemCount: perfiles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(perfiles[index].imagen),
                            radius: 35,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 190,
                            child: Text(
                              perfiles[index].nombre,
                              style: GoogleFonts.quantico(fontSize: 17),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Card(
                            color: Colors.blue.shade100,
                            child: IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () async {
                                perfilVer = await datosPerfilId(
                                    perfiles[index].idPerfil);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            VerPerfilAmigo(
                                              perfil: perfilVer!,
                                            )));
                              },
                            ),
                          ),
                          Card(
                            color: Colors.red,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return dialogEliminaAmigo(
                                        context,
                                        perfiles[index].nombre,
                                        widget.perfil.id!,
                                        perfiles[index].idPerfil);
                                  },
                                );

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MisAmigos(perfil: widget.perfil)));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}
