import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:move/models/evento_completo.dart';
import 'dart:developer' as dev;
import '../models/evento.dart';

// Metodos que recogen las respueta en formato JSON del servidor y guarda la informacion en modelos en la aplicacion

//Metodo actualiza un evento
Future<void> updateEvento(Evento evento) async {
  await http.put(
      Uri.parse(
        'https://apimove.somee.com/api/Evento/update',
      ),
      body: jsonEncode(evento),
      headers: {'Content-Type': 'application/json'});
}

//Metodo que crea un nuevo evento
Future<void> createEvento(Evento evento) async {
  try {
    await http.post(Uri.parse('https://apimove.somee.com/api/Evento/insert'),
        body: jsonEncode(evento),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    dev.log(e.toString());
  }
}

//Metodo que devulve una lista de eventos con el nombre de deporte  y la imagen asociada al deporte
Future<List<EventoCompleto>> getEventos(int idPerfil) async {
  var completer = Completer<List<EventoCompleto>>();

  //Respuesta del servidor
  var respuesta = await http
      .get(Uri.parse('https://apimove.somee.com/api/Evento/activos/$idPerfil'));

  //Si la respuesta es correcta leemos la lista de objetos JSON y lo añadimos a una lista de objetos EventoCompleto
  if (respuesta.statusCode == 200) {
    List<EventoCompleto> eventos = [];
    var datos = jsonDecode(respuesta.body);
    for (var element in datos) {
      eventos.add(EventoCompleto.fromJson(element));
    }
    completer.complete(eventos);
  }
  return completer.future;
}

//Metodo que devulve una lista de eventos con el nombre de deporte  y la imagen asociada al deporte
Future<List<EventoCompleto>> getEventosParticipando(int idPerfil) async {
  var completer = Completer<List<EventoCompleto>>();
  //Respuesta del servidor
  var respuesta = await http.get(
      Uri.parse('https://apimove.somee.com/api/Evento/participando/$idPerfil'));

  //Si la respuesta es correcta leemos la lista de objetos JSON y lo añadimos a una lista de objetos EventoCompleto
  if (respuesta.statusCode == 200) {
    List<EventoCompleto> eventos = [];
    var datos = jsonDecode(respuesta.body);
    for (var element in datos) {
      eventos.add(EventoCompleto.fromJson(element));
    }
    completer.complete(eventos);
  }
  return completer.future;
}

//Metodo que devulve el id del ultimo evento creado por un id de perfil
Future<int> idUltimoEvento(int idPerfil) async {
  var complete = Completer<int>();
  //Respuesta del servidor
  var respuesta = await http
      .get(Uri.parse('https://apimove.somee.com/api/Evento/ultimo/$idPerfil'));
  //Si la respuesta es correcta leemos la lista de objetos JSON en la posicion 0 y devulve el id de evento que buscamos
  if (respuesta.statusCode == 200) {
    var datos = jsonDecode(respuesta.body);
    var idEvento = datos[0]["id"];
    complete.complete(idEvento);
  }
  return complete.future;
}

//Metodo que devulve una lista de eventos creado por el usuario
Future<List<EventoCompleto>> getEventosMios(int idPerfil) async {
  var completer = Completer<List<EventoCompleto>>();
  //Respuesta del servidor
  var respuesta = await http.get(
      Uri.parse('https://apimove.somee.com/api/Evento/activos/user/$idPerfil'));
  // Si la respuesta es correcta leemos la lista de objetos JSON y lo añadimos a una lista de objetos EventoCompleto
  if (respuesta.statusCode == 200) {
    List<EventoCompleto> eventos = [];
    var datos = jsonDecode(respuesta.body);
    for (var element in datos) {
      eventos.add(EventoCompleto.fromJson(element));
    }
    completer.complete(eventos);
  }
  return completer.future;
}

//Metodo que elimina un evento de la base de datos
Future<void> deleteEvento(int id) async {
  await http
      .delete(Uri.parse('https://apimove.somee.com/api/Evento/delete/$id'));
}
