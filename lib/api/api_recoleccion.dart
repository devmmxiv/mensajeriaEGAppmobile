import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app_mensajeria/functions/format_functions.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/models/municpios_model.dart';
import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';
import 'package:http/http.dart' as http;

Future<List<Recoleccion>> getRecolecciones(UserLogeado singleton) async {
  //String server = dotenv.env['SERVER'].toString();
  String versionapi = dotenv.env['VERSIONAPI'].toString();
  List<Recoleccion> recolecciones = [];
  String path = 'recoleccion-entrega/';
  try {
    if (UserLogeado().getPerfil() == 'CLIENTE') {
      path = 'recoleccion-entrega/recoleccionclienteenvia/${UserLogeado().id}';
    } else {
      //empleado
      if (UserLogeado().isAdministrador) {
        path = '$versionapi/recoleccion-entrega/recoleccionempleadoadmin';
      } else {
        path =
            '$versionapi/recoleccion-entrega/recoleccionempleado/${UserLogeado().id}';
      }
    }
    //Uri uri = Uri.http(server, '$versionapi/$path/');

    final response = await http.get(getUri(path));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var d in jsonData) {
        recolecciones.add(Recoleccion(
            d["id"],
            d["fechaCreacion"],
            d["nombreRecibe"],
            d["apellidoRecibe"],
            d["telefonoRecibe"],
            d["totalCobrar"],
            d["precioEnvio"],
            d["direccionEntrega"],
            d["zonaEntrega"],
            d["estado"],
            d["tipoPago"],
            // d["clienteEnvia"]["id"],
            Municipio.fromJson(d['municipioRecibe']),
            Cliente.fromJson(d['clienteEnvia']),
           // Direccion.fromJson(d["direccionEnvia"]),
           // Municipio.fromJson(d['municipioEnvia']),
            Empleado.fromJson(d['empleadoAsignado'])));
        // print(recolecciones[0].empleadoAsignado.id);
      }
    }
  } catch (e) {
    rethrow;
  }

  return recolecciones;
}
