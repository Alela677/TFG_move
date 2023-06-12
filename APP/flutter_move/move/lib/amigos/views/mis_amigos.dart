import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/amigos/widgets/navigator_button_amigos.dart';
import 'package:move/amigos/widgets/list_amigos.dart';
import 'package:move/models/perfil_user.dart';

class MisAmigos extends StatefulWidget {
  const MisAmigos({super.key, required this.perfil});

  final PerfilUser perfil;

  @override
  State<MisAmigos> createState() => _MisAmigosState();
}

class _MisAmigosState extends State<MisAmigos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Mis amigos', style: GoogleFonts.quantico(fontSize: 25)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Amigos(perfil: widget.perfil),
          const Spacer(),
          NavegadorButtonAmigos(perfil: widget.perfil),
        ],
      ),
    );
  }
}
