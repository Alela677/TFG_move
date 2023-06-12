// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../formularios/form_registro.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<Registro> {
  static const String titulo = 'Registrate en move';
  static const String subtitulo =
      'Aquí podrás conectar con personas que comparten tu pasión por el deporte y' +
          ' descubrir eventos deportivos en tu área.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            titulo,
                            style: GoogleFonts.quantico(fontSize: 37),
                          ),
                          subtitle: Text(
                            subtitulo,
                            style: GoogleFonts.quantico(fontSize: 15),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 32, 136, 255),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const FormRegistro(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
