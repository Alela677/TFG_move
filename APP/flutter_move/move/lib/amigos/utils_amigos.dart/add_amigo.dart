// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:move/amigos/views/mis_amigos.dart';
import '../../crud/crud_amigos.dart';
import '../../models/amigos.dart';
import '../../models/perfil_user.dart';

void addAmigo(PerfilUser perfil, int perfil2, BuildContext context) async {
  Amigos amigo =
      Amigos(solicitante: perfil.id!, perfil1: perfil.id!, perfil2: perfil2);

  await insertAmigo(amigo);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => MisAmigos(perfil: perfil)));
}
