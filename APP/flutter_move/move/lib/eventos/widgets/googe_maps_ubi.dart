import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//Mapa que muestra con un marcador la ubicacion del evento
class GoogleMapsUbi extends StatefulWidget {
  const GoogleMapsUbi(
      {super.key, required this.latitude, required this.longitud});

  final double longitud;
  final double latitude;
  @override
  State<GoogleMapsUbi> createState() => _GoogleMapsUbiState();
}

class _GoogleMapsUbiState extends State<GoogleMapsUbi> {
  late LatLng _kMapCenter;
  late final CameraPosition _malaga;

  //Inicializa la vista con las coordenadas del evento y creamos la posicion inicial del mapa
  @override
  void initState() {
    super.initState();
    //Coodenadas
    _kMapCenter = LatLng(widget.latitude, widget.longitud);
    // Posicion de la camara
    _malaga =
        CameraPosition(target: _kMapCenter, zoom: 15.0, tilt: 0, bearing: 0);
  }

  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Ubicación evento'),
      ),
      body: GoogleMap(
        initialCameraPosition: _malaga,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: false,
        markers: {
          //Marcador de la ubicacion
          Marker(
            markerId: const MarkerId('evento'),
            position: LatLng(widget.latitude, widget.longitud),
          ),
        },
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
