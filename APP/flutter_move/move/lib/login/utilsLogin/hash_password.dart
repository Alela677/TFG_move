// ignore_for_file: file_names

import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String valor) {
  var bytesPass = utf8.encode(valor);
  var digest = sha256.convert(bytesPass);
  return digest.toString();
}
