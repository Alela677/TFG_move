import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../crud/crud_amigos.dart';

AlertDialog dialogEliminaAmigo(
    BuildContext context, String nombre, int idPerfil, int idBorrar) {
  var alert = AlertDialog(
    backgroundColor: Colors.white,
    title: const Text('Eliminar amigo'),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          Text('¿Quiere dejar de seguir a $nombre ?'),
        ],
      ),
    ),
    actions: [
      TextButton(
        child: Text('Aceptar',
            style: GoogleFonts.quantico(color: Colors.blue, fontSize: 20)),
        onPressed: () async {
          await deleteAmigo(idPerfil, idBorrar);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text(
          'Cancelar',
          style: GoogleFonts.quantico(color: Colors.blue, fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  return alert;
}
