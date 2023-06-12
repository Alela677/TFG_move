import 'package:flutter/material.dart';
import 'package:move/amigos/views/mis_amigos.dart';
import 'package:move/eventos/views/eventos_activos.dart';
import 'package:move/inicio/widgets/perfil_avatar.dart';
import 'package:move/models/perfil_user.dart';
import 'package:move/perfil/utils_perfil/dialog_eliminar_perfil.dart';
import 'package:move/perfil/views/ver_perfil.dart';

// Vista incial de la aplicacion
class InicioView extends StatefulWidget {
  const InicioView({super.key, required this.usuario});

  final PerfilUser usuario;

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar donde se muestra la imagen de perfil y un texto
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(380),
          child: Container(
            color: Colors.blue,
            child: Column(
              children: [
                const SizedBox(height: 50),
                //Widget que muestra la imagen del perfil
                PerfilAvatar(
                  perfil: widget.usuario,
                ),
                //Texto con nombre de perfil
                ListTile(
                    title: Text(
                      widget.usuario.nombreUno.toString(),
                      style: const TextStyle(fontSize: 45, color: Colors.white),
                    ),
                    subtitle: const SizedBox(
                      child: FittedBox(
                        child: Text('¿Qué plan tienes para hoy?',
                            style:
                                TextStyle(fontSize: 25, color: Colors.white)),
                      ),
                    )),
              ],
            ),
          )),
      // Lista que contiene botones de navegacion por la aplicacion
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Boton Mi perfil
              SizedBox(
                height: 150,
                width: 150,
                child: FloatingActionButton(
                  heroTag: 'bt1',
                  backgroundColor: Colors.blue.shade300,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPerfil(
                          perfil: widget.usuario,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Column(
                      children: [
                        Icon(
                          Icons.person,
                          size: 90,
                          color: Colors.grey.shade700,
                        ),
                        const Center(
                            child: FittedBox(
                          child: Text('Mi perfil'),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              //Boton Amigos
              SizedBox(
                height: 150,
                width: 150,
                child: FloatingActionButton(
                  heroTag: 'bt2',
                  backgroundColor: Colors.blue.shade300,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MisAmigos(perfil: widget.usuario)));
                  },
                  child: ListTile(
                    title: Column(
                      children: [
                        Icon(
                          Icons.people,
                          size: 90,
                          color: Colors.grey.shade700,
                        ),
                        const Center(
                            child: FittedBox(
                          child: Text('Amigos'),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          //Boton Eventos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: FloatingActionButton(
                  heroTag: 'bt3',
                  backgroundColor: Colors.blue.shade300,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventosActivos(perfil: widget.usuario),
                        ));
                  },
                  child: ListTile(
                    title: Column(
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 90,
                          color: Colors.grey.shade700,
                        ),
                        const Center(
                            child: FittedBox(
                          child: Text('Eventos'),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              //Boton eliminar perfil
              SizedBox(
                height: 150,
                width: 150,
                child: FloatingActionButton(
                  heroTag: 'bt4',
                  backgroundColor: Colors.blue.shade300,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        //AlertDialog eliminar el perfil de usuario en caso de aceptar
                        return eliminarPerfilCompleto(context, widget.usuario);
                      },
                    );
                  },
                  child: ListTile(
                    title: Column(
                      children: [
                        Icon(
                          Icons.hail_rounded,
                          size: 90,
                          color: Colors.grey.shade700,
                        ),
                        const Center(
                            child: FittedBox(
                          child: Text('Eliminar perfil'),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
