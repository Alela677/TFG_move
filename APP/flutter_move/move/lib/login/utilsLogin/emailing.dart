// ignore_for_file: non_constant_identifier_names, constant_identifier_names, depend_on_referenced_packages, avoid_print
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

Future enviarEmail({message, email, usuario, destinatario}) async {
  const service_id = 'service_aczql06';
  const template_id = 'template_5x1je66';
  const user_id = 'Ccuh18oIrlOr-zmu2';

  var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  try {
    var response = await http.post(url,
        headers: {
          'origin': '<http://localhost>',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'service_id': service_id,
          'template_id': template_id,
          'user_id': user_id,
          'template_params': {
            'message': message,
            'to_email': email,
            'usuario': usuario,
            'user_email': email,
          }
        }));
    print('[FEED BACK RESPONSE]');
    print(response.body);
  } catch (error) {
    print('[SEND FEEDBACK MAIL ERROR]');
  }
}

int aleatorio(int min, int max) {
  return Random().nextInt(max - min) + min;
}
