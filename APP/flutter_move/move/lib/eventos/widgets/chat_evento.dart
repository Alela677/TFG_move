import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/crud/crud_mensaje.dart';
import 'package:move/eventos/utilsEventos/mensajes_chat.dart';
import 'package:move/models/evento_completo.dart';
import 'package:move/models/mensaje.dart';
import 'package:move/models/mensaje_nombre.dart';
import 'package:move/models/perfil_user.dart';

class ChatEvento extends StatefulWidget {
  const ChatEvento({super.key, required this.evento, required this.perfil});

  final PerfilUser perfil;
  final EventoCompleto evento;

  @override
  State<ChatEvento> createState() => _ChatEventoState();
}

//Vista que muestra el widget de el chat
class _ChatEventoState extends State<ChatEvento> {
  final TextEditingController controler = TextEditingController();
  List<MensajeNombre> mensajes = [];

  late Timer timer;

  //Metodo que actualiza lso mensajes del chat
  Future<void> _actualizarMensajes() async {
    try {
      final nuevosMensajes = await getMensajesEvento(widget.evento.id);
      setState(() {
        mensajes = nuevosMensajes;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //Inicia un timer al mostrar la vista que realiza peticiones a la base de datos cada medio segundo
  @override
  void initState() {
    super.initState();

    // Inicia el timer que actualiza los mensajes cada 500 milisegundos
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _actualizarMensajes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: SizedBox(
          child: FittedBox(
            child: Text(widget.evento.descripcion,
                style: const TextStyle(fontSize: 25, color: Colors.white)),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 20.0),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/Logo_transparente.png',
              width: 250,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mensajes.length,
              itemBuilder: (context, index) {
                //Si lo mensajes son del usuario se muestra como enviados
                if (mensajes[index].perfil == widget.perfil.id) {
                  return ListTile(
                    subtitle: mensajeEnviado(mensajes[index]),
                  );
                } else {
                  //Si no se muestran como recibidos
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          mensajes[index].nombrePerfil,
                          style: GoogleFonts.quantico(fontSize: 20),
                        ),
                      ],
                    ),
                    subtitle: mensajeRecibido(mensajes[index]),
                  );
                }
              },
            ),
          ),
          //Introduce el texto que va a enviar
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controler,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      hintText: 'Escriba un mensaje',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          final nuevoMensaje = Mensaje(
                            id: 0,
                            perfil: widget.perfil.id!,
                            evento: widget.evento.id,
                            mensaje: controler.text,
                          );
                          await createMensaje(nuevoMensaje);
                          controler.clear();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Cancela el timer al cerrar la pantalla
    timer.cancel();
    super.dispose();
  }
}
