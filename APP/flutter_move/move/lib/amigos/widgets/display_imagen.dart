import 'package:flutter/material.dart';
import 'package:move/models/imagenes.dart';

class DisplayImagenAmigo extends StatefulWidget {
  const DisplayImagenAmigo({super.key, required this.imagen});

  final Imagenes imagen;

  @override
  State<DisplayImagenAmigo> createState() => _DisplayImagenAmigoState();
}

class _DisplayImagenAmigoState extends State<DisplayImagenAmigo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.network(widget.imagen.imagen),
          ),
        ],
      ),
    );
  }
}
