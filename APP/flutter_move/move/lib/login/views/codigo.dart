import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/login/formularios/form_codigo.dart';
import '../../models/usuario.dart';

//ignore: must_be_immutable
class CodigoEmail extends StatefulWidget {
  const CodigoEmail({super.key, required this.usuario});

  final Usuario usuario;
  @override
  State<CodigoEmail> createState() => _CodigoEmailState();
}

class _CodigoEmailState extends State<CodigoEmail> {
  final titulo = '¡Ya casi está!';
  final subtitulo =
      'Por favor, revise su bandeja de entrada y busque un correo electrónico de nuestra empresa que contenga el código de seguridad. Si no encuentra el correo electrónico, asegúrese de revisar la carpeta de spam o el correo no deseado, una vez que tenga el código de seguridad, ingréselo en el campo correspondiente en nuestra plataforma de inicio de sesión para acceder a su cuenta.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 58),
                child: ListTile(
                  title: Text(
                    titulo,
                    style: GoogleFonts.quantico(fontSize: 37),
                  ),
                  subtitle: Text(
                    subtitulo,
                    style: GoogleFonts.quantico(fontSize: 15),
                  ),
                ),
              ),
              Container(
                height: 390,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 32, 136, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                alignment: Alignment.center,
                child: FormCodigo(usuario: widget.usuario),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
