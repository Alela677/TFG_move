import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//Metodo que pregunta al usuario si da permisos para acceder a su ubicacion
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error("Location permission denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  Position position = await Geolocator.getCurrentPosition();

  return position;
}

//Devuelve un las coodenadas de la ubicacion del usuario si no tiene permiso devulve una por defecto
Future<LatLng> ubicacionUsuario() async {
  try {
    Position posi = await determinePosition();
    return LatLng(posi.latitude, posi.longitude);
  } catch (e) {
    return const LatLng(40.339559296875564, -4.150309385023392);
  }
}
