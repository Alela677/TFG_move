// ignore_for_file: unused_local_variable, use_build_context_synchronously, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/crud/crud_usuario.dart';
import 'package:move/login/utilsLogin/emailing.dart';
import 'package:move/login/views/login.dart';
import '../../global_utils/styleTextForm.dart';
import '../../models/usuario.dart';
import '../utilsLogin/hash_password.dart';
import '../../global_utils/validacion_campos.dart';

class FormRecuPass extends StatefulWidget {
  const FormRecuPass({super.key});

  @override
  State<FormRecuPass> createState() => _FormRecuPassState();
}

class _FormRecuPassState extends State<FormRecuPass> {
  final controllerEmail = TextEditingController();
  final controllerCodigo = TextEditingController();
  final controllerPass = TextEditingController();

  bool visibleCodigo = false;
  bool visiblePass = false;
  String btnRecuperar = 'Enviar email';
  int codigo = 0;

  Usuario? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, right: 20),
          child: Image.asset(
            'assets/images/Logo_transparente.png',
            width: 250,
          ),
        ),
        ListTile(
          title: Row(
            children: [
              const Icon(Icons.email),
              Text(
                'Introduce un email',
                style: GoogleFonts.quantico(fontSize: 20),
              ),
            ],
          ),
          subtitle: TextFormField(
            controller: controllerEmail,
            maxLines: 1,
            decoration: decoration,
          ),
        ),
        Visibility(
          visible: visibleCodigo,
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
              maxLines: 1,
              decoration: decoration,
            ),
          ),
        ),
        Visibility(
          visible: visiblePass,
          child: ListTile(
            title: Row(
              children: [
                const Icon(Icons.lock_person),
                Text(
                  'Nueva contraseña',
                  style: GoogleFonts.quantico(fontSize: 20),
                ),
              ],
            ),
            subtitle: TextFormField(
              obscureText: true,
              controller: controllerPass,
              maxLines: 1,
              decoration: decoration,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
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
                  if (btnRecuperar == 'Enviar email') {
                    user = await compruebaUser(controllerEmail.text);
                    codigo = aleatorio(10000, 100000);
                    await enviarEmail(
                        email: controllerEmail.text,
                        message: codigo,
                        usuario: user?.usuario);

                    ScaffoldMessenger.of(context).showSnackBar(
                        mensaje('Se le ha enviado un correo con el código'));

                    setState(() {
                      visibleCodigo = true;
                      btnRecuperar = 'Comprobar codigo';
                    });
                  }

                  if (btnRecuperar == 'Comprobar codigo') {
                    if (codigo.toString() == controllerCodigo.text) {
                      setState(() {
                        visiblePass = true;
                        btnRecuperar = 'Guardar contraseña';
                      });
                    }
                  }

                  if (btnRecuperar == 'Guardar contraseña') {
                    if (controllerPass.text.isNotEmpty) {
                      Usuario nuevaPass = Usuario(
                          id: user?.id,
                          usuario: user?.usuario,
                          password: hashPassword(controllerPass.text),
                          email: user?.email);

                      await actualizarUsuario(nuevaPass);

                      controllerEmail.clear();
                      controllerCodigo.clear();
                      controllerPass.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                          mensaje('Contraseña actualizada correctamente'));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ));
                    }
                  }
                },
                child: Text(btnRecuperar,
                    style: const TextStyle(fontSize: 15, color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(350, 40),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Volver',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
