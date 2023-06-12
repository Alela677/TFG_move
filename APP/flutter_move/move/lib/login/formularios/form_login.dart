// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, unused_import, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/inicio/inicio_view.dart';
import 'package:move/login/utilsLogin/hash_password.dart';
import 'package:move/login/utilsLogin/validacion_usuario.dart';
import 'package:move/login/views/recuperapass.dart';
import 'package:move/models/perfil_user.dart';
import 'package:move/models/usuario.dart';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:move/perfil/views/editar_perfil.dart';
import '../../crud/crud_perfil_user.dart';
import '../../crud/crud_usuario.dart';
import '../../global_utils/styleTextForm.dart';
import '../../models/imagen_perfil.dart';
import '../../perfil/views/crear_perfil.dart';
import '../../global_utils/validacion_campos.dart';
import '../views/registro.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final controllerUser = TextEditingController();
  final controllerPass = TextEditingController();
  Usuario? user;
  PerfilUser? perfil;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50, right: 20),
          child: Image.asset(
            'assets/images/Logo_transparente.png',
            width: 250,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.person),
                  Text(
                    'Usuario',
                    style: GoogleFonts.quantico(fontSize: 20),
                  ),
                ],
              ),
              TextFormField(
                controller: controllerUser,
                decoration: decoration,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Icon(Icons.lock_person),
                  Text(
                    'Contraseña',
                    style: GoogleFonts.quantico(fontSize: 20),
                  ),
                ],
              ),
              TextFormField(
                obscureText: true,
                maxLines: 1,
                controller: controllerPass,
                decoration: decoration,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: () async {
                      user = await datosUsuario(
                          controllerUser.text, controllerPass.text);

                      if (user != null) {
                        if (validarUsuario(
                            controllerUser.text, controllerPass.text, user!)) {
                          dev.log('sasaasas');
                          perfil = await datosPerfil(user!.id);
                          dev.log('sasa');
                          if (perfil != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InicioView(
                                          usuario: perfil!,
                                        )));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CrearPerfil(
                                    usuario: user,
                                  ),
                                ));
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(mensaje(
                            'No se pudo encontrar el usuario, por favor intentelo de nuevo'));
                      }

                      controllerPass.clear();
                      controllerUser.clear();
                    },
                    child: const Text('Iniciar sesión',
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Registro(),
                          ));
                    },
                    child: const Text('Registrate',
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                  ),
                ],
              ),
              SizedBox(
                height: 9,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecuperaPass(),
                      ));
                },
                child: const Text(
                  '¿Has olvidado tu contraseña?',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
