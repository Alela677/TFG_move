// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/crud/crud_evento.dart';
import 'package:move/crud/crud_participante.dart';
import 'package:move/eventos/views/mis_eventos.dart';
import 'package:move/models/evento_completo.dart';
import 'package:move/models/perfil_user.dart';
import 'dart:developer' as dev;
import '../widgets/evento_card.dart';
import '../widgets/navigator_button.dart';

//Vista que muestra los evento activos
class EventosActivos extends StatefulWidget {
  const EventosActivos({super.key, required this.perfil});

  final PerfilUser perfil;

  @override
  State<EventosActivos> createState() => _EventosActivosState();
}

class _EventosActivosState extends State<EventosActivos> {
  bool searchBar = false;

  @override
  void initState() {
    super.initState();
    searchBar = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos', style: GoogleFonts.quantico(fontSize: 25)),
        backgroundColor: Colors.blue,
        actions: [
          //Activa o descativa la barra de busqueda
          IconButton(
              onPressed: () {
                setState(() {
                  if (searchBar == false) {
                    searchBar = true;
                  } else {
                    searchBar = false;
                  }
                });
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Column(
        children: [
          //Widget que ejecuta el meto que consulta a la API
          FutureBuilder<List<EventoCompleto>>(
              //Metodo que devulve la lista de eventos activos para el usuario
              future: getEventos(widget.perfil.id!),
              builder: (context, snapshot) {
                //Mientra obtiene respuesta muestra un circulo de carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                      child: Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ));
                } else {
                  List<EventoCompleto> eventos = snapshot.data!;
                  //Llenamos la lista con la respuesta si esta vacia nos indica que no hay eventos
                  if (eventos.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text('No hay evento activos'),
                      ),
                    );
                  } else {
                    //Si tiene datos muetsa una lista con los eventos
                    return Expanded(
                      child: EventoCard(
                        eventos: eventos,
                        perfil: widget.perfil,
                        searchBar: searchBar,
                      ),
                    );
                  }
                }
              }),
          //Barra de navegacion eventos
          NavigatorButtonEvento(perfil: widget.perfil),
        ],
      ),
    );
  }
}
