// ignore: file_names
// ignore_for_file: constant_identifier_names, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:move/models/perfil_user.dart';
import '../models/evento.dart';

const regex_email =
    "[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:.[a-zA-Z0-9-]+)*\$";
const regex_password =
    "(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[.#?!@\$%^&*-]).{8,}\$";

bool validateEmail(String value) {
  Pattern pattern = regex_email;
  RegExp regex = RegExp(pattern.toString());
  if (!regex.hasMatch(value)) {
    return false;
  } else {
    return true;
  }
}

bool validatePassword(String value) {
  Pattern pattern = regex_password;
  RegExp regex = RegExp(pattern.toString());
  if (!regex.hasMatch(value)) {
    return false;
  } else {
    return true;
  }
}

SnackBar mensaje(String mensaje) {
  var snackBar = SnackBar(
    content: Center(
      child: Text(mensaje),
    ),
  );

  return snackBar;
}

String validarCamposRegistros(String email, String password, String password2) {
  if (!validateEmail(email)) {
    return 'Formato de email no valido';
  } else if (!validatePassword(password)) {
    return 'Contraseña: 1 mayuscula, 1 minuscula, 1 numero, 1 caracter especial y 8 carcateres minimo';
  } else if (password != password2) {
    return 'Las contraseñas no coinciden';
  } else {
    return 'Valido';
  }
}

String validaCrearPerfil(PerfilUser perfil) {
  if (perfil.nombreUno!.isEmpty) {
    return 'Escriba un nombre de usuario';
  } else if (perfil.deportes!.isEmpty) {
    return 'Escriba al menos un deporte';
  } else if (perfil.descripcion!.isEmpty) {
    return 'Escriba una descripcion breve sobre usted';
  } else if (perfil.edad == null) {
    return 'Introdizca su edad';
  } else if (perfil.sexo == null) {
    return 'Indique a que sexo pertenece';
  } else if (perfil.localidad == null) {
    return 'Introduce una localidad';
  } else {
    return 'Valido';
  }
}

String validarCamposEventos(Evento evento, String deporte) {
  if (evento.descripcion.isEmpty) {
    return 'Escriba una breve descripción';
  } else if (evento.ciudad.isEmpty) {
    return 'Introduzca una ciudad';
  } else if (deporte.isEmpty || deporte == null) {
    return 'Introduzca un deporte';
  } else if (evento.numParticipante == null || evento.numParticipante <= 0) {
    return 'Introduzca un numero de participantes';
  } else {
    return 'Valido';
  }
}
