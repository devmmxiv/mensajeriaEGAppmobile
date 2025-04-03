import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_mensajeria/functions/format_functions.dart';

Future getClienteByUser(String username) async {

  String versionapi = dotenv.env['VERSIONAPI'].toString();

  try {

final response = await http
        .get(getUri('$versionapi/cliente/clientebyusernameforperfil/$username'));
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      return body;
    } else {
      return "";
    }
  } catch (e) {
    return "";
  }
}
