// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:move/crud/crud_perfil_user.dart';
import 'package:move/login/views/login.dart';
import 'package:move/models/perfil_user.dart';

AlertDialog eliminarPerfilCompleto(BuildContext context, PerfilUser perfil) {
  var alert = AlertDialog(
    title: const Text('Eliminar perfil'),
    content: const SingleChildScrollView(
      child: ListBody(
        children: [
          Text('¿Seguro que quiere eliminar tu perfil?'),
        ],
      ),
    ),
    actions: [
      TextButton(
          onPressed: () async {
            await elimiarPerfilCompleto(perfil.id!, perfil.idUsuario!);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
              (route) => false,
            );
          },
          child: const Text('Aceptar')),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar')),
    ],
  );

  return alert;
}
