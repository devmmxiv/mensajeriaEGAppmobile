import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_mensajeria/functions/format_functions.dart';

Future getEmpleadoByUser(String username) async {
  // String server = dotenv.env['SERVER'].toString();
  String versionapi = dotenv.env['VERSIONAPI'].toString();

  try {
    //Uri uri =
    //  Uri.http(server, '$versionapi/empleado/empleadobyusername/$username');
    final response = await http
        .get(getUri('$versionapi/empleado/empleadobyusername/$username'));

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
