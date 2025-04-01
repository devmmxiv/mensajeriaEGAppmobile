import 'dart:convert';

//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_mensajeria/functions/format_functions.dart';

Future<bool> updateEstadoRecoleccion(int id, String estado) async {
  bool dato = false;
  // String server = dotenv.env['SERVER'].toString();
  try {
    // Uri uri = Uri.http(server, '/api/v1/recoleccion-entrega/update/estado/$id');

    final response = await http.patch(
        getUri('/api/v1/recoleccion-entrega/update/estado/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': id, 'estado': estado}));

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      dato = true;
    }
  } catch (e) {
    //print('actualizar estado' + e.toString());
    dato = false;
  }
  return dato;
}
