import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future getClienteByUser(String username) async {
  String server = dotenv.env['SERVER'].toString();
  String versionapi = dotenv.env['VERSIONAPI'].toString();

  try {
    Uri uri =
        Uri.http(server, '$versionapi/cliente/clientebyusername/$username');
    final response = await http.get(uri);

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
