import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app_mensajeria/functions/format_functions.dart';
import 'package:mobile_app_mensajeria/models/cliente_recoleccion_entrega_model.dart';
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
      path =
          '$versionapi/recoleccion-entrega/recoleccionclienteenvia/${UserLogeado().id}';
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
            d['empleadoAsignado'] == null
                ? Empleado()
                : Empleado.fromJson(d['empleadoAsignado'])));
        // print(recolecciones[0].empleadoAsignado.id);
      }
    }
  } catch (e) {
    rethrow;
  }

  return recolecciones;
}

Future<List<CabeceraRecoleccion>> getEncabezadoRecolecciones(
    UserLogeado singleton) async {
  List<CabeceraRecoleccion> encabezados = [];
  String versionapi = dotenv.env['VERSIONAPI'].toString();
  String path =
      '$versionapi/recoleccion-entrega/listadoagrupacionclientes/${singleton.id}';
  try {
    final response = await http.get(getUri(path));
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);
      for (var d in jsonData) {
        encabezados.add(CabeceraRecoleccion(
            d["id"],
            d["cantidad"],
            d["nombre"],
            d["apellido"],
            d["telefono"],
            d["direccion"],
            d["zona"],
            d["municipio"]));
      }
    }
  } catch (e) {
    encabezados = [];
  }
  return encabezados;
}

Future<List<ClienteRecoleccionEntrega>> getClienteRecoleccionesNocerradas(
    UserLogeado singleton) async {
  String versionapi = dotenv.env['VERSIONAPI'].toString();
  List<ClienteRecoleccionEntrega> clientes = [];
  String path = '';
  try {
    if (singleton.perfilUsuario== 'CLIENTE') {
      path =
          '$versionapi/cliente/clienterecoleccionesnocerradas/${singleton.id}';
    } else {
      //empleado

      path =
          '$versionapi/cliente/clientesrecoleccionesnocerradasporempleado/${UserLogeado().id}';
    }
    //Uri uri = Uri.http(server, '$versionapi/$path/');

    final response = await http.get(getUri(path));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);
      if(jsonData.length>0){
      for (var d in  jsonData) {
        clientes.add(ClienteRecoleccionEntrega(
            id: d["id"],
            nombre: d["nombre"],
            apellido: d["apellido"],
            telefono: d["telefono"],
            recolecciones: List<dynamic>.from(d['envios'])
                .map((i) => RecoleccionEntrega.fromJson(i))
                .toList(),
            direcciones: List<dynamic>.from(d['direcciones'])
                .map((i) => Direccion.fromJson(i))
                .toList()));
        // print(recolecciones[0].empleadoAsignado.id);
      }
      }
    }
  } catch (e) {
    rethrow;
  }

  return clientes;
}
