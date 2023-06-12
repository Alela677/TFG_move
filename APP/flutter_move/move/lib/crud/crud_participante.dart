import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:move/models/perfil_completo.dart';
import '../models/participante.dart';
import 'dart:developer' as dev;

Future<void> createParticipante(Participante participante) async {
  try {
    await http.post(
        Uri.parse('https://apimove.somee.com/api/Participante/insert'),
        body: jsonEncode(participante),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    dev.log(e.toString());
  }
}

Future<int> participando(int idEvento) async {
  var complete = Completer<int>();
  var respuesta = await http.get(Uri.parse(
      'https://apimove.somee.com/api/Participante/numParticipantes/$idEvento'));
  if (respuesta.statusCode == 200) {
    var datos = jsonDecode(respuesta.body);
    var numParticipantes = datos[0][""];
    complete.complete(numParticipantes);
  } else {
    complete.completeError("No se pudo obtener el número de participantes");
  }

  return complete.future;
}

Future<void> deleteParticipante(int evento, int perfil) async {
  await http.delete(Uri.parse(
      'https://apimove.somee.com/api/Participante/delete/$evento/$perfil'));
}

Future<List<PerfilNombreImagen>> getParticipantesEvento(int id) async {
  var complete = Completer<List<PerfilNombreImagen>>();
  var respuesta = await http.get(Uri.parse(
      'https://apimove.somee.com/api/Participante/participantesEvento/$id'));
  if (respuesta.statusCode == 200) {
    List<PerfilNombreImagen> perfiles = [];
    var datos = jsonDecode(respuesta.body);
    for (var element in datos) {
      perfiles.add(PerfilNombreImagen.fromJson(element));
    }
    complete.complete(perfiles);
  }
  return complete.future;
}
