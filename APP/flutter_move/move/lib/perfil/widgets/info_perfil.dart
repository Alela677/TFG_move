import 'package:flutter/material.dart';

import '../../models/perfil_user.dart';

class InfoPerfil extends StatefulWidget {
  const InfoPerfil({super.key, required this.perfil});

  final PerfilUser perfil;

  @override
  State<InfoPerfil> createState() => _InfoPerfilState();
}

class _InfoPerfilState extends State<InfoPerfil> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.perfil.nombreUno.toString(),
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cake,
              size: 30,
            ),
            const SizedBox(width: 8.0),
            Text(
              widget.perfil.edad.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
            const SizedBox(width: 24.0),
            const Icon(
              Icons.person,
              size: 30,
            ),
            const SizedBox(width: 8.0),
            Text(
              widget.perfil.sexo.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(width: 24.0),
            const Icon(
              Icons.location_city,
              size: 30,
            ),
            const SizedBox(width: 8.0),
            Text(
              widget.perfil.localidad.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Deportes',
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(
          height: 25,
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.perfil.deportes.toString(),
              style: const TextStyle(
                fontSize: 34.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Text(
          'Descripción',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 35,
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.perfil.descripcion.toString(),
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
