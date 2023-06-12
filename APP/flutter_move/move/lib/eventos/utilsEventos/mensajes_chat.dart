import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:move/models/mensaje_nombre.dart';

//Burbuja de chat enviado por el usuario
BubbleSpecialOne mensajeEnviado(MensajeNombre mensaje) {
  var mensajeEnviar = mensaje.mensaje;
  var mensajeEnviado = BubbleSpecialOne(
    text: mensajeEnviar,
    isSender: true,
    color: const Color(0xFF1B97F3),
    textStyle: const TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
  );

  return mensajeEnviado;
}

//Burbuja de chat recibida por el usuario
BubbleSpecialOne mensajeRecibido(MensajeNombre mensaje) {
  var mensajeRecibir = mensaje.mensaje;
  var mensajeRecibido = BubbleSpecialOne(
    text: mensajeRecibir,
    isSender: false,
    color: const Color.fromARGB(255, 181, 181, 182),
    textStyle: const TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
  );

  return mensajeRecibido;
}
