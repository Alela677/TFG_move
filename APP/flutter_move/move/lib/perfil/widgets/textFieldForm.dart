import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../global_utils/styleTextForm.dart';

//ignore: must_be_immutable
class TextFieldFormMove extends StatefulWidget {
  TextFieldFormMove(
      {super.key,
      required this.controller,
      required this.decoration,
      required this.titulo});

  InputDecoration decoration;
  TextEditingController controller;
  String titulo;

  @override
  State<TextFieldFormMove> createState() => _TextFieldFormMoveState();
}

class _TextFieldFormMoveState extends State<TextFieldFormMove> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.titulo,
        style: GoogleFonts.quantico(fontSize: 20),
      ),
      subtitle: TextFormField(
        controller: widget.controller,
        decoration: decoration,
      ),
    );
  }
}
