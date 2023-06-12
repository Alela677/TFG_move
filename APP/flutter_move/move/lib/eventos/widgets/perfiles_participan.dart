import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/crud/crud_participante.dart';
import 'package:move/models/perfil_completo.dart';

//Vista que muestra los perfiles que participan en cada evento
class PerfilesParticipan extends StatefulWidget {
  const PerfilesParticipan({super.key, required this.idEvento});

  final int idEvento;
  @override
  State<PerfilesParticipan> createState() => _PerfilesParticipanState();
}

class _PerfilesParticipanState extends State<PerfilesParticipan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Participantes'),
      ),
      body: FutureBuilder<List<PerfilNombreImagen>>(
        future: getParticipantesEvento(widget.idEvento),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<PerfilNombreImagen> perfiles = snapshot.data!;
            if (perfiles.isEmpty) {
              return const Center(
                child: Text('No se encontraron participantes'),
              );
            } else {
              return ListView.builder(
                itemCount: perfiles.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(perfiles[index].imagen),
                              radius: 40,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              perfiles[index].nombre,
                              style: GoogleFonts.quantico(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
