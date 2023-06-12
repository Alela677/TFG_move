// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/eventos/views/eventos_participo.dart';
import 'package:move/eventos/widgets/chat_evento.dart';
import 'package:move/eventos/widgets/perfiles_participan.dart';
import 'package:move/models/evento_completo.dart';
import 'package:move/models/perfil_user.dart';
import '../../crud/crud_participante.dart';
import 'googe_maps_ubi.dart';

//Vista que muestra la vista de evento en los que participa el usuario misma estructura de actulizar evento
class EventoCardParticipo extends StatefulWidget {
  const EventoCardParticipo(
      {super.key, required this.perfil, required this.eventos});
  final PerfilUser perfil;
  final List<EventoCompleto> eventos;
  @override
  State<EventoCardParticipo> createState() => _EventoCardParticipoState();
}

class _EventoCardParticipoState extends State<EventoCardParticipo> {
  int numParticipando = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.eventos.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.eventos[index].imagen))),
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Text(
                  widget.eventos[index].nombreDeporte,
                  style: GoogleFonts.quantico(fontSize: 25),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Text(widget.eventos[index].descripcion),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Row(
                  children: [
                    const Icon(Icons.date_range),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.eventos[index].fecha
                        .split('T')[0]
                        .replaceAll('-', '/')),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Row(
                  children: [
                    const Icon(Icons.schedule),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.eventos[index].fecha.split('T')[1].substring(0,
                        widget.eventos[index].fecha.split('T')[1].length - 3)),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Row(
                  children: [
                    const Icon(Icons.location_city),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.eventos[index].ciudad),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatEvento(
                                  evento: widget.eventos[index],
                                  perfil: widget.perfil),
                            ));
                      },
                      icon: const Icon(
                        Icons.message,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoogleMapsUbi(
                                  latitude: widget.eventos[index].latitude,
                                  longitud: widget.eventos[index].longitude),
                            ));
                      },
                      icon: const Icon(
                        Icons.place,
                        size: 30,
                      ),
                    )
                  ],
                ),
                Row(children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PerfilesParticipan(
                                idEvento: widget.eventos[index].id),
                          ));
                    },
                    icon: const Icon(Icons.people),
                  ),
                  FutureBuilder<int>(
                    future: participando(widget.eventos[index].id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Colors.blue,
                        );
                      } else {
                        numParticipando = snapshot.data!;
                        return Text(
                            ' $numParticipando / ${widget.eventos[index].numParticipante}');
                      }
                    },
                  ),
                ]),
              ],
            ),
            Container(
              color: Colors.blue,
              height: 40,
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  if (widget.eventos[index].idPerfil != widget.perfil.id) {
                    await deleteParticipante(
                        widget.eventos[index].id, widget.perfil.id!);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventosParticipo(perfil: widget.perfil),
                        ));
                  }
                },
                child: Text(
                  'Salir',
                  style:
                      GoogleFonts.quantico(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 35),
          ],
        );
      },
    );
  }
}
