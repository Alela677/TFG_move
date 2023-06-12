// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/amigos/utils_amigos.dart/buscar_amigo.dart';
import 'package:move/models/perfil_completo.dart';
import 'package:move/models/perfil_user.dart';
import '../utils_amigos.dart/add_amigo.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.perfil}) : super(key: key);

  final PerfilUser perfil;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = '';

  _SearchPageState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Buscar amigos', style: GoogleFonts.quantico(fontSize: 25)),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SearchBar(
              controller: _filter,
              hintText: 'Introduce el nombre ',
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          StreamBuilder<List<PerfilNombreImagen>>(
              stream: searchItems(_searchText, widget.perfil.id!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final items = snapshot.data!;
                return SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 500,
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      10.0), // Agregamos un padding vertical de 10
                              child: SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          NetworkImage(items[index].imagen),
                                      radius: 35,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 230,
                                      child: Text(
                                        items[index].nombre,
                                        style:
                                            GoogleFonts.quantico(fontSize: 17),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Card(
                                      color: Colors.blue.shade100,
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () async {
                                          addAmigo(widget.perfil,
                                              items[index].idPerfil, context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
