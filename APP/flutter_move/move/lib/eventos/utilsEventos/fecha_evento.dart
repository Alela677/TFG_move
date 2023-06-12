import 'package:flutter/material.dart';
import '../../models/evento_completo.dart';

// Metodo concatena la fecha y la hora introducida en el evento
String fechaEvento(DateTime fecha, TimeOfDay hora) {
  late String isoDate;
  isoDate =
      '${fecha.year}-${fecha.month}-${fecha.day} ${hora.hour}:${hora.minute}';
  return isoDate;
}

//Parsea la hora de un datetime a TimeOfDay
TimeOfDay horaDateTime(EventoCompleto evento) {
  DateTime fechaCompleta = DateTime.parse(evento.fecha);
  DateTime horaFecha = DateTime(
      fechaCompleta.year,
      fechaCompleta.month,
      fechaCompleta.day,
      int.parse(evento.fecha.split('T')[1].split(':')[0]),
      int.parse(evento.fecha.split('T')[1].split(':')[1]));
  return TimeOfDay.fromDateTime(horaFecha);
}
