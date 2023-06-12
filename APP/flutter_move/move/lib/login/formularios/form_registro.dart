// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../crud/crud_usuario.dart';
import '../../global_utils/styleTextForm.dart';
import 'package:move/login/utilsLogin/hash_password.dart';
import 'package:move/global_utils/validacion_campos.dart';
import 'package:move/login/views/codigo.dart';
import '../../models/usuario.dart';
import 'dart:developer' as dev;

class FormRegistro extends StatefulWidget {
  const FormRegistro({super.key});

  @override
  State<FormRegistro> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegistro> {
  final controlUsuario = TextEditingController();
  final controlEmail = TextEditingController();
  final controlPassword = TextEditingController();
  final controlPassword2 = TextEditingController();

  Usuario? existeUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 20),
                child: Image.asset(
                  'assets/images/Logo_transparente.png',
                  width: 250,
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    const Icon(Icons.person),
                    Text(
                      'Usuario',
                      style: GoogleFonts.quantico(fontSize: 20),
                    ),
                  ],
                ),
                subtitle: TextFormField(
                  controller: controlUsuario,
                  maxLines: 1,
                  decoration: decoration,
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    const Icon(Icons.email),
                    Text(
                      'Email',
                      style: GoogleFonts.quantico(fontSize: 20),
                    ),
                  ],
                ),
                subtitle: TextFormField(
                  controller: controlEmail,
                  maxLines: 1,
                  decoration: decoration,
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    const Icon(Icons.lock_person),
                    Text(
                      'Contraseña',
                      style: GoogleFonts.quantico(fontSize: 20),
                    ),
                  ],
                ),
                subtitle: TextFormField(
                  obscureText: true,
                  controller: controlPassword,
                  maxLines: 1,
                  decoration: decoration,
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    const Icon(Icons.lock_person),
                    Text(
                      'Repetir contraseña',
                      style: GoogleFonts.quantico(fontSize: 20),
                    ),
                  ],
                ),
                subtitle: TextFormField(
                  obscureText: true,
                  controller: controlPassword2,
                  maxLines: 1,
                  decoration: decoration,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(370, 40),
                      ),
                      onPressed: () async {
                        String mensajeValidacion = validarCamposRegistros(
                            controlEmail.text,
                            controlPassword.text,
                            controlPassword2.text);

                        if (mensajeValidacion != 'Valido') {
                          dev.log(mensajeValidacion);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(mensaje(mensajeValidacion));
                        } else {
                          existeUser = await compruebaUser(controlEmail.text);
                          if (existeUser == null) {
                            Usuario registro = Usuario(
                                id: 0,
                                usuario: controlUsuario.text,
                                password: hashPassword(controlPassword.text),
                                email: controlEmail.text);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CodigoEmail(
                                    usuario: registro,
                                  ),
                                ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(mensaje('El usuario ya existe'));
                          }
                        }
                      },
                      child: const Text('Siguiente',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(370, 40),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
