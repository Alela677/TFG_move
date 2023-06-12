import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/crud/crud_evento.dart';
import 'package:move/eventos/widgets/evento_card_mios.dart';
import 'package:move/eventos/widgets/navigator_button.dart';
import 'package:move/models/evento_completo.dart';

import '../../models/perfil_user.dart';

//Vista eventos creados por el usuario misma estructura que eventos activos
class MisEventos extends StatefulWidget {
  const MisEventos({super.key, required this.perfil});

  final PerfilUser perfil;

  @override
  State<MisEventos> createState() => _MisEventosState();
}

class _MisEventosState extends State<MisEventos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Mis eventos', style: GoogleFonts.quantico(fontSize: 25)),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getEventosMios(widget.perfil.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                    child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ));
              } else {
                List<EventoCompleto> eventos = snapshot.data!;
                if (eventos.isEmpty) {
                  return const Expanded(
                      child: Center(
                    child: Text('No tiene eventos'),
                  ));
                } else {
                  return Expanded(
                      child: EventosCardMios(
                    eventos: eventos,
                    perfil: widget.perfil,
                  ));
                }
              }
            },
          ),
          NavigatorButtonEvento(perfil: widget.perfil),
        ],
      ),
    );
  }
}
