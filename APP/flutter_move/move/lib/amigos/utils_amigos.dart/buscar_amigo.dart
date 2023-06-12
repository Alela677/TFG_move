// ignore_for_file: depend_on_referenced_packages

import '../../crud/crud_amigos.dart';
import '../../models/perfil_completo.dart';

Stream<List<PerfilNombreImagen>> searchItems(String searchText, int id) async* {
  List<PerfilNombreImagen> items = [];

  items = await getPerfilSugerencias(id);

  final filteredItems =
      items.where((item) => item.nombre.contains(searchText)).toList();
  yield filteredItems;
}
