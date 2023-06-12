import 'package:move/models/usuario.dart';
import 'hash_password.dart';

bool validarUsuario(String usuario, String password, Usuario user) {
  password = hashPassword(password);
  if (usuario == user.usuario && password == user.password) {
    return true;
  } else {
    return false;
  }
}
