// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/crud/crud_deporte.dart';
import 'package:move/eventos/widgets/navigator_button.dart';
import 'package:move/global_utils/localidades.dart';
import 'package:move/models/evento.dart';
import 'package:move/models/perfil_user.dart';
import 'package:move/models/deporte.dart';
import '../../global_utils/validacion_campos.dart';
import '../utilsEventos/fecha_evento.dart';
import '../widgets/google_maps.dart';

//Vista para crear el evento
class CrearEventoView extends StatefulWidget {
  const CrearEventoView({super.key, required this.perfil});
  final PerfilUser perfil;

  @override
  _CrearEventoViewState createState() => _CrearEventoViewState();
}

class _CrearEventoViewState extends State<CrearEventoView> {
  // Variables para almacenar los datos del evento
  int _participantes = 0;
  String _descripcion = '';
  DateTime _fecha = DateTime.now();
  TimeOfDay _hora = TimeOfDay.now();
  String? _deporteSeleccionado;
  String urlImagen = '';
  int index = 0;
  List<Deporte> deportes = [];
  List<String> ciudades = [];
  String ciudad = '';

  void _actualizarFecha(DateTime fechaSeleccionada) {
    setState(() {
      _fecha = fechaSeleccionada;
    });
  }

  void _actualizarHora(TimeOfDay horaSeleccionada) {
    setState(() {
      _hora = horaSeleccionada;
    });
  }

  //Llenamos la lista de deportes disponibles
  void deportesList() async {
    List<Deporte> list = await getDeportes();
    setState(() {
      deportes = list;
    });
  }

  //Iniciamos la vista con una imagen por defecto
  @override
  void initState() {
    super.initState();
    deportesList();
    urlImagen =
        'https://www.sopitas.com/wp-content/uploads/2016/12/messi-nfl-sky-hd.gif';
    ciudades.addAll(listaLocalidades);
  }

  //Limpiamos los campos al salir de la vista
  @override
  void dispose() {
    super.dispose();
    _descripcion = '';
    _deporteSeleccionado = '';
    _participantes = 0;
    deportes.clear();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Crear evento', style: GoogleFonts.quantico(fontSize: 25)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Imagen que se muestra en la vista
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(urlImagen),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      // Campo de texto para la descripcion
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                        ),
                        onChanged: (valor) {
                          setState(() {
                            _descripcion = valor;
                          });
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                'Fecha: ${_fecha.day}/${_fecha.month}/${_fecha.year} '),
                          ),
                          //Icono que muestra la ayuda para introducir la fecha
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: _fecha,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              ).then((fechaSeleccionada) {
                                if (fechaSeleccionada != null) {
                                  _actualizarFecha(fechaSeleccionada);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Hora: ${_hora.format(context)}'),
                          ),
                          //Icono que muestra la ayuda para introducir la hora
                          IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: _hora,
                              ).then((horaSeleccionada) {
                                if (horaSeleccionada != null) {
                                  _actualizarHora(horaSeleccionada);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      // Lista de ciudades disponibles
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Ciudad',
                        ),
                        items: ciudades.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            ciudad = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 10.0),
                      //Lista de deportes disponibles
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Deporte',
                        ),
                        value: _deporteSeleccionado,
                        items: deportes.map((deporte) {
                          return DropdownMenuItem<String>(
                            value: deporte.nombre,
                            child: Text(deporte.nombre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            index = deportes.indexWhere(
                                (element) => element.nombre == value);
                            urlImagen = deportes[index].imagen;
                            _deporteSeleccionado = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10.0),
                      //Caja de texto para introducir los participantes
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Numero de participantes',
                        ),
                        onChanged: (valor) {
                          setState(() => _participantes = int.parse(valor));
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: Text(
                            'Siguiente',
                            style: GoogleFonts.quantico(
                                color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            //Creamos el evento
                            Evento evento = Evento(
                                id: 0,
                                descripcion: _descripcion,
                                numParticipante: _participantes,
                                fecha: fechaEvento(_fecha, _hora),
                                ciudad: ciudad,
                                longitude: 0.0,
                                latitude: 0.0,
                                idDeporte: deportes[index].id,
                                idPerfil: widget.perfil.id!);
                            //Validamos los campos dele evento
                            String validar = validarCamposEventos(
                                evento, deportes[index].nombre);

                            //Si no es valido muestra un warning
                            if (validar != 'Valido') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(mensaje(validar));
                            } else {
                              //Si es correcto pasamos a la siguiente vista para introducir la ubicacion
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoogleMaps(
                                      evento: evento, perfil: widget.perfil),
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          NavigatorButtonEvento(perfil: widget.perfil),
        ],
      ),
    );
  }
}
