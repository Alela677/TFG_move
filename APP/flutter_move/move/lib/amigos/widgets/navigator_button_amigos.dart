import 'package:flutter/material.dart';
import 'package:move/amigos/views/mis_amigos.dart';
import 'package:move/amigos/views/buscador.dart';
import 'package:move/inicio/inicio_view.dart';
import '../../models/perfil_user.dart';

class NavegadorButtonAmigos extends StatefulWidget {
  const NavegadorButtonAmigos({super.key, required this.perfil});

  final PerfilUser perfil;

  @override
  State<NavegadorButtonAmigos> createState() => _InicioAmigosState();
}

class _InicioAmigosState extends State<NavegadorButtonAmigos> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.grey.shade500,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Buscar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Mis amigos',
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
                ));
          } else if (_selectedIndex == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPage(perfil: widget.perfil)));
          } else if (_selectedIndex == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MisAmigos(
                    perfil: widget.perfil,
                  ),
                ));
          }
        });
      },
    );
  }
}
