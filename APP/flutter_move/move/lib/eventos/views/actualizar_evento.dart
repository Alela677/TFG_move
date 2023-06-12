// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/crud/crud_evento.dart';
import 'package:move/eventos/views/mis_eventos.dart';
import 'package:move/models/perfil_user.dart';
import '../../crud/crud_deporte.dart';
import '../../global_utils/localidades.dart';
import '../../global_utils/validacion_campos.dart';
import '../../models/deporte.dart';
import '../../models/evento.dart';
import '../../models/evento_completo.dart';
import '../utilsEventos/fecha_evento.dart';

//Vista para actualizar informacion del evento
class ActualizarEvento extends StatefulWidget {
  const ActualizarEvento(
      {super.key, required this.evento, required this.perfil});

  final EventoCompleto evento;
  final PerfilUser perfil;
  @override
  State<ActualizarEvento> createState() => _ActualizarEventoState();
}

class _ActualizarEventoState extends State<ActualizarEvento> {
  // Variables para almacenar los datos del evento
  final TextEditingController _descripcion = TextEditingController();
  final TextEditingController _numParticipantes = TextEditingController();
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

  //Iniciamos la vista con los datos del evento
  @override
  void initState() {
    super.initState();
    deportesList();
    urlImagen = widget.evento.imagen;
    ciudades.addAll(listaLocalidades);
    _deporteSeleccionado = widget.evento.nombreDeporte;
    _descripcion.text = widget.evento.descripcion;
    _fecha = DateTime.parse(widget.evento.fecha.split('T')[0]);
    _hora = horaDateTime(widget.evento);
    _numParticipantes.text = widget.evento.numParticipante.toString();
    ciudad = widget.evento.ciudad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Actualizar evento',
            style: GoogleFonts.quantico(fontSize: 25)),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Imagen deporte del eventp
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(urlImagen), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 4.0),
                // Descripcion del evento
                TextFormField(
                  controller: _descripcion,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Fecha: ${_fecha.day}/${_fecha.month}/${_fecha.year} '),
                    ),
                    // Muestra la ayuda para introducir la fecha
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
                    // Muestra la ayuda para introducir la hora
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
                //Lista de ciudades disponibles
                DropdownButtonFormField(
                  value: ciudad,
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
                //Lista de deportes disponible
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
                      index = deportes
                          .indexWhere((element) => element.nombre == value);
                      urlImagen = deportes[index].imagen;
                      _deporteSeleccionado = value;
                    });
                  },
                ),
                const SizedBox(height: 10.0),
                //Caja de texto para introducir los participantes
                TextFormField(
                  controller: _numParticipantes,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Numero de participantes',
                  ),
                ),
                const SizedBox(height: 10.0),
                //Boton para altuzalzar el evento
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text(
                    'Actualizar',
                    style:
                        GoogleFonts.quantico(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    //Validamos los campos del evento
                    if (_descripcion.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          mensaje('Escriba una breve descripción'));
                    } else {
                      if (ciudad.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(mensaje('Introduzca una ciudad'));
                      } else if (_deporteSeleccionado == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(mensaje('Introduzca un deporte'));
                      } else if (int.parse(_numParticipantes.text) <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            mensaje('Introduzca un numero de participantes'));
                      } else {
                        //Si no hay nigun campo vacio actualizamos el evento
                        Evento evento = Evento(
                            id: widget.evento.id,
                            descripcion: _descripcion.text,
                            numParticipante: int.parse(_numParticipantes.text),
                            fecha: fechaEvento(_fecha, _hora),
                            ciudad: ciudad,
                            longitude: widget.evento.longitude,
                            latitude: widget.evento.latitude,
                            idDeporte: deportes[index].id,
                            idPerfil: widget.perfil.id!);
                        await updateEvento(evento);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MisEventos(
                                      perfil: widget.perfil,
                                    )),
                            (route) => false);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
