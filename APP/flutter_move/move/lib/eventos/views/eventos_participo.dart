import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/crud/crud_evento.dart';
import 'package:move/eventos/widgets/evento_card_participo.dart';
import 'package:move/models/evento_completo.dart';

import '../../models/perfil_user.dart';
import '../widgets/navigator_button.dart';

//Vista eventos donde participa el usuario misma estructura que eventos activos
class EventosParticipo extends StatefulWidget {
  const EventosParticipo({super.key, required this.perfil});

  final PerfilUser perfil;

  @override
  State<EventosParticipo> createState() => _EventosParticipoState();
}

class _EventosParticipoState extends State<EventosParticipo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Participando', style: GoogleFonts.quantico(fontSize: 25)),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getEventosParticipando(widget.perfil.id!),
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
                    child: Text('No tiene eventos proximos'),
                  ));
                } else {
                  return Expanded(
                    child: EventoCardParticipo(
                        perfil: widget.perfil, eventos: eventos),
                  );
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
