import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:move/eventos/utilsEventos/alert_dialog_crear.dart';
import 'package:move/eventos/utilsEventos/permisos_ubicacion.dart';

import '../../models/evento.dart';
import '../../models/perfil_user.dart';

//Vista que muestra el mapa pa añadir la ubicacion
class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key, required this.evento, required this.perfil});

  final PerfilUser perfil;
  final Evento evento;

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late GoogleMapController mapController;

  LatLng position = const LatLng(0.0, 0.0);

  //Posicion que marca el usuario en el mapa
  void addPosition(LatLng latLng) {
    setState(() {
      position = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Añade la ubicación',
            style: GoogleFonts.quantico(fontSize: 25),
          ),
        ),
        //Consultamos la ubicacion del usuario
        body: FutureBuilder<LatLng>(
          future: ubicacionUsuario(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              //Si el usuario dio permisos y tiene la ubicacion activada se muestra la ciudad donde se encuenta
              // si no la el mapa incializara en Madrid
              LatLng kMapCenter = snapshot.data!;
              CameraPosition inicio = CameraPosition(
                  target: kMapCenter, zoom: 9, tilt: 0, bearing: 0);

              return GoogleMap(
                initialCameraPosition: inicio,
                scrollGesturesEnabled: true,
                rotateGesturesEnabled: false,
                onTap: (latLng) {
                  //Guardamos las coodenadas de la posicion que indico el usuario
                  addPosition(latLng);
                  //Seteamos las coordenadas al evento
                  widget.evento.setLongitud(latLng.longitude);
                  widget.evento.setLatitud(latLng.latitude);
                  Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      //Mustra un dialogo para comfirmar la creacion del evento
                      showDialog(
                        context: context,
                        builder: (context) {
                          return dialogCrear(
                              context, widget.evento, widget.perfil);
                        },
                      );
                    },
                  );
                },
                markers: {
                  //Marcador donde pulsa el usuario
                  Marker(
                    markerId: const MarkerId('evento'),
                    position: LatLng(position.latitude, position.longitude),
                  ),
                },
                onMapCreated: (controller) {
                  mapController = controller;
                },
              );
            }
          },
        ));
  }
}
