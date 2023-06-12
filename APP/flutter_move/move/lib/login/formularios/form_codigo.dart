// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/crud/crud_usuario.dart';
import 'package:move/login/utilsLogin/emailing.dart';
import 'package:move/login/views/login.dart';
import '../../global_utils/styleTextForm.dart';
import '../../models/usuario.dart';

//Vista que muestra el codigo
//ignore: must_be_immutable
class FormCodigo extends StatefulWidget {
  const FormCodigo({super.key, required this.usuario});

  final Usuario usuario;

  @override
  State<FormCodigo> createState() => _FormCodigoState();
}

class _FormCodigoState extends State<FormCodigo> {
  bool visible = false;
  final controllerCodigo = TextEditingController();
  var codigo;
  bool get wantKeepAlive => true;

  @override
  void initState() {
    setState(() {
      codigo = aleatorio(10000, 100000);
    });
    enviarEmail(
        message: codigo,
        email: widget.usuario.email.toString(),
        usuario: widget.usuario.usuario);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50, right: 20),
          child: Image.asset(
            'assets/images/Logo_transparente.png',
            width: 250,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: ListTile(
            title: Row(
              children: [
                const Icon(Icons.numbers_sharp),
                Text(
                  'Introduce el código',
                  style: GoogleFonts.quantico(fontSize: 20),
                ),
              ],
            ),
            subtitle: TextFormField(
              controller: controllerCodigo,
              decoration: decoration,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: const Size(350, 40),
                  ),
                  onPressed: () async {
                    if (controllerCodigo.text == codigo.toString()) {
                      await crearUsuario(widget.usuario);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Activar cuenta',
                    style: TextStyle(color: Colors.black),
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(350, 40),
                ),
                onPressed: () {
                  setState(() {
                    codigo = aleatorio(10000, 100000);
                  });
                  enviarEmail(
                      message: codigo,
                      email: widget.usuario.email.toString(),
                      usuario: widget.usuario.usuario);
                },
                child: const Text('Nuevo código',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
