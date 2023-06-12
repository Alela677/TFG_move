import 'package:flutter/material.dart';
import 'package:move/eventos/views/crear_evento.dart';
import 'package:move/eventos/views/eventos_activos.dart';
import 'package:move/eventos/views/eventos_participo.dart';
import 'package:move/eventos/views/mis_eventos.dart';
import 'package:move/inicio/inicio_view.dart';
import 'package:move/models/perfil_user.dart';

//Barra de navegacion para los eventos
class NavigatorButtonEvento extends StatefulWidget {
  const NavigatorButtonEvento({super.key, required this.perfil});

  final PerfilUser perfil;
  @override
  State<NavigatorButtonEvento> createState() => _NavigatorButtonEventoState();
}

class _NavigatorButtonEventoState extends State<NavigatorButtonEvento> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.grey.shade500,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: ("Eventos"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Crear',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Mis eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Agenda',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;

          if (_selectedIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InicioView(usuario: widget.perfil),
              ),
            );
          } else if (_selectedIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventosActivos(perfil: widget.perfil),
              ),
            );
          } else if (_selectedIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CrearEventoView(perfil: widget.perfil),
              ),
            );
          } else if (_selectedIndex == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MisEventos(perfil: widget.perfil),
              ),
            );
          } else if (_selectedIndex == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventosParticipo(perfil: widget.perfil),
              ),
            );
          }
        });
      },
    );
  }
}
