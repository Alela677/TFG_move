import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:move/models/mensaje.dart';
import 'package:http/http.dart' as http;
import 'package:move/models/mensaje_nombre.dart';

Future<List<MensajeNombre>> getMensajesEvento(int idEvento) async {
  var respuesta = await http
      .get(Uri.parse('https://apimove.somee.com/api/Mensajes/$idEvento'));
  var complete = Completer<List<MensajeNombre>>();

  if (respuesta.statusCode == 200) {
    List<MensajeNombre> mensajes = [];
    var datos = jsonDecode(respuesta.body);

    for (var element in datos) {
      mensajes.add(MensajeNombre.fromJson(element));
    }

    complete.complete(mensajes);
  }
  return complete.future;
}

Future<void> createMensaje(Mensaje mensaje) async {
  try {
    await http.post(Uri.parse('https://apimove.somee.com/api/Mensajes/insert'),
        body: jsonEncode(mensaje),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    dev.log(e.toString());
  }
}
