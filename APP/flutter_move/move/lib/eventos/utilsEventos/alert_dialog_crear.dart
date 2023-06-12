// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:move/crud/crud_evento.dart';
import 'package:move/crud/crud_participante.dart';
import 'package:move/eventos/views/mis_eventos.dart';
import 'package:move/models/evento.dart';
import 'package:move/models/perfil_user.dart';
import '../../models/participante.dart';

//Dialogo con el usuario para que indique si quiere crear el evento o no
AlertDialog dialogCrear(
    BuildContext context, Evento evento, PerfilUser perfil) {
  var dialog = AlertDialog(
    title: const Text('Ubicación'),
    content: const Text('¿Añadir ubicación al evento?'),
    actions: [
      // Boton aceptar
      TextButton(
          onPressed: () async {
            //Si acepta registra el evento en la base de datos
            await createEvento(evento);
            //Obtiene el id del evento creado
            int idEvento = await idUltimoEvento(perfil.id!);
            Participante anfitrion =
                Participante(id: 0, perfil: perfil.id!, evento: idEvento);
            //Añadimos al usuario que creo el evento como participante
            await createParticipante(anfitrion);

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MisEventos(perfil: perfil),
                ));
          },
          child: const Text('Aceptar')),
      //Boton cancelar
      TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar')),
    ],
  );

  return dialog;
}
