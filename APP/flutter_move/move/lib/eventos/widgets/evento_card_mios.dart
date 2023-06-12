// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/crud/crud_evento.dart';
import 'package:move/eventos/views/actualizar_evento.dart';
import 'package:move/eventos/views/mis_eventos.dart';
import 'package:move/eventos/widgets/chat_evento.dart';
import 'package:move/eventos/widgets/perfiles_participan.dart';
import 'package:move/models/perfil_user.dart';
import '../../crud/crud_participante.dart';
import '../../models/evento_completo.dart';
import 'googe_maps_ubi.dart';

// Vista que muestra toda la informacion del evento creado por el usuario
class EventosCardMios extends StatefulWidget {
  const EventosCardMios(
      {super.key, required this.eventos, required this.perfil});
  final PerfilUser perfil;
  final List<EventoCompleto> eventos;
  @override
  State<EventosCardMios> createState() => _EventosCardMiosState();
}

class _EventosCardMiosState extends State<EventosCardMios> {
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
            //Imagen deporte
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
            //Nombre del deporte
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.eventos[index].nombreDeporte,
                  style: GoogleFonts.quantico(fontSize: 25),
                ),
              ],
            ),
            //Descripcion del evento
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(widget.eventos[index].descripcion),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            //Fecha del evento
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 7,
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
                // Hora del evento
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
                //Ciudad del evento
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
              height: 10,
            ),
            Row(
              children: [
                Row(
                  children: [
                    //Icono para acceder al chat
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
                    //Icono para acceder a la ubicacion
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
                  //Icono que muestra una lista que los participantes
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
                  //Wisget que realiza la consulta a la API
                  FutureBuilder<int>(
                    //Metodo que devulve un resultado de la API
                    future: participando(widget.eventos[index].id),
                    builder: (context, snapshot) {
                      //Mientras espera la respuesta muestra un circulo de carga
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Colors.blue,
                        );
                        //Cuando obtiene resultado alamcena el id en un variable
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Texto que actua como boton navega a la vista para actualizar el evento
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActualizarEvento(
                                evento: widget.eventos[index],
                                perfil: widget.perfil),
                          ));
                    },
                    child: Text(
                      'Actualizar',
                      style: GoogleFonts.quantico(
                          fontSize: 15, color: Colors.white),
                    ),
                  ),
                  //Texto que actua como boton elimina el evento
                  TextButton(
                    onPressed: () async {
                      await deleteEvento(widget.eventos[index].id);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MisEventos(
                                  perfil: widget.perfil,
                                )),
                      );
                    },
                    child: Text(
                      'Eliminar',
                      style: GoogleFonts.quantico(
                          fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
          ],
        );
      },
    );
  }
}
