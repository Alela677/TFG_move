// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/eventos/views/eventos_participo.dart';
import '../../crud/crud_participante.dart';
import '../../global_utils/validacion_campos.dart';
import '../../models/evento_completo.dart';
import '../../models/participante.dart';
import '../../models/perfil_user.dart';
import 'googe_maps_ubi.dart';

//Vista que muestra la vista de evento activos misma estructura de actulizar evento
class EventoCard extends StatefulWidget {
  const EventoCard(
      {super.key,
      required this.eventos,
      required this.perfil,
      required this.searchBar});

  final PerfilUser perfil;
  final List<EventoCompleto> eventos;
  final bool searchBar;

  @override
  State<EventoCard> createState() => _EventoCardState();
}

class _EventoCardState extends State<EventoCard> {
  int numParticipando = 0;
  List<EventoCompleto> _eventos = [];
  String _query = '';
  @override
  void initState() {
    super.initState();
    _eventos = widget.eventos;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Visibility(
          visible: widget.searchBar,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SearchBar(
              hintText: 'Busca por deporte o ciudad',
              onChanged: (value) {
                setState(() {
                  _query = value;
                  _eventos = widget.eventos
                      .where((evento) =>
                          evento.nombreDeporte
                              .toLowerCase()
                              .contains(_query.toLowerCase()) ||
                          evento.ciudad
                              .toLowerCase()
                              .contains(_query.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: ListView.builder(
            itemCount: _eventos.length,
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
                              image: NetworkImage(_eventos[index].imagen))),
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        _eventos[index].nombreDeporte,
                        style: GoogleFonts.quantico(fontSize: 25),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Text(_eventos[index].descripcion),
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
                          Text(_eventos[index]
                              .fecha
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
                          Text(
                            _eventos[index].fecha.split('T')[1].substring(0,
                                _eventos[index].fecha.split('T')[1].length - 3),
                          ),
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
                          Text(_eventos[index].ciudad),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.people,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        FutureBuilder<int>(
                          future: participando(_eventos[index].id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                color: Colors.blue,
                              );
                            } else {
                              numParticipando = snapshot.data!;
                              return Text(
                                  ' $numParticipando / ${_eventos[index].numParticipante}');
                            }
                          },
                        ),
                      ]),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GoogleMapsUbi(
                                        latitude: _eventos[index].latitude,
                                        longitud: _eventos[index].longitude),
                                  ));
                            },
                            icon: const Icon(
                              Icons.place,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.blue,
                    height: 40,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await addParticipante(index, context);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventosParticipo(perfil: widget.perfil),
                            ));
                      },
                      child: Text(
                        'Participar',
                        style: GoogleFonts.quantico(
                            fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> addParticipante(int index, BuildContext context) async {
    int comprobar = await participando(widget.eventos[index].id);
    if (comprobar < widget.eventos[index].numParticipante) {
      Participante participante = Participante(
          id: 0, perfil: widget.perfil.id!, evento: widget.eventos[index].id);
      await createParticipante(participante);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(mensaje('El evento esta completo'));
    }
  }
}
