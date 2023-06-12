import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/login/formularios/form_recuperar_pass.dart';

class RecuperaPass extends StatefulWidget {
  const RecuperaPass({super.key});

  @override
  State<RecuperaPass> createState() => _RecuperaPassState();
}

class _RecuperaPassState extends State<RecuperaPass> {
  static const String titulo = 'Recuperar contraseña';
  static const String subtitulo =
      '¡Bienvenido/a a Move, la red social de eventos deportivos más emocionante del mundo! Aquí podrás conectar con personas que comparten tu pasión por el deporte y descubrir eventos deportivos en tu área.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              ListTile(
                title: Text(
                  titulo,
                  style: GoogleFonts.quantico(fontSize: 30),
                ),
                subtitle: Text(
                  subtitulo,
                  style: GoogleFonts.quantico(fontSize: 15),
                ),
              ),
              Container(
                height: 600,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 32, 136, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                alignment: Alignment.center,
                child: const FormRecuPass(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
