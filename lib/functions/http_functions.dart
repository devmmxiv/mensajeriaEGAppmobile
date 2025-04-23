import 'dart:convert';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app_mensajeria/db/operation_db.dart';
import 'package:mobile_app_mensajeria/functions/format_functions.dart';
import 'package:mobile_app_mensajeria/models/cliente_recoleccion_entrega_model.dart';
import 'package:mobile_app_mensajeria/models/municpios_model.dart';
import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';
import 'package:http/http.dart' as http;

Future<List<Recoleccion>> getRecoleccionesHttp() async {
  //String server = dotenv.env['SERVER'].toString();
  List<Recoleccion> recolecciones = [];

  try {
    // Uri uri = Uri.http(server, '/api/v1/recoleccion-entrega/');
    final response = await http.get(getUri('/api/v1/recoleccion-entrega/'));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var d in jsonData) {
        Recoleccion.fromJson(d);
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
            Municipio.fromJson(d['municipioRecibe']),
            Cliente.fromJson(d['clienteEnvia']),
            Empleado.fromJson(d['empleadoAsignado'])));
      }
    }
  } catch (e) {
    rethrow;
  }

  return recolecciones;
}

Future<List<Recoleccion>> getRecoleccionesEntregadasHttp1() async {
  //String server = dotenv.env['SERVER'].toString();
  List<Recoleccion> recolecciones = [];

  try {
    // Uri uri = Uri.http(server, '/api/v1/recoleccion-entrega/');
    final response = await http.get(getUri('/api/v1/recoleccion-entrega/'));

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
            Municipio.fromJson(d['municipioRecibe']),
            Cliente.fromJson(d['clienteEnvia']),
            Empleado.fromJson(d['empleadoAsignado'])));
      }
    }
  } catch (e) {
    try {
      recolecciones = await Operation.instance.getRecoleccionesEntregadas();
    } catch (e) {
      recolecciones = [];
    }
  }

  return recolecciones;
}

Future<bool> createRecoleccion(Recoleccion recoleccion) async {
  bool dato = false;

  RecoleccionInsert r = RecoleccionInsert.fromJson(recoleccion.toMap());
  // String server = dotenv.env['SERVER'].toString();
  try {
    //Uri.http(server, '/api/v1/recoleccion-entrega/');

    final response = await http.post(
      getUri('/api/v1/recoleccion-entrega/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(r.toMap()),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      dato = true;
    }
  } catch (e) {
    dato = false;
  }
  return dato;
}

Future<bool> createRecoleccionEntrega(RecoleccionEntrega recoleccion) async {
  bool dato = false;

  RecoleccionInsert r = RecoleccionInsert.fromJson(recoleccion.toMap());
  // String server = dotenv.env['SERVER'].toString();
  try {
    //Uri.http(server, '/api/v1/recoleccion-entrega/');

    final response = await http.post(
      getUri('/api/v1/recoleccion-entrega/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(r.toMap()),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      dato = true;
    }
  } catch (e) {
    dato = false;
  }
  return dato;
}

Future<bool> updateRecoleccionEntrega(RecoleccionEntrega recoleccion) async {
  bool dato = false;
  try {
    Object body;
    if (recoleccion.empleadoAsignado!.id == null) {
      RecoleccionInsert r = RecoleccionInsert.fromJson(recoleccion.toMap());
      body = jsonEncode(r.toMap());
    } else {
      body = jsonEncode(recoleccion.toMap());
    }
    final response = await http.put(
        getUri('/api/v1/recoleccion-entrega/update/${recoleccion.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body
        //  body: jsonEncode(recoleccion.toMap()),
        );

    if (response.statusCode == 200) {
      dato = true;
    }
  } catch (e) {
    dato = false;
  }
  return dato;
}

Future<bool> updateRecoleccion(Recoleccion recoleccion) async {
  bool dato = false;
  try {
    Object body;
    if (recoleccion.empleadoAsignado!.id == null) {
      RecoleccionInsert r = RecoleccionInsert.fromJson(recoleccion.toMap());
      body = jsonEncode(r.toMap());
    } else {
      body = jsonEncode(recoleccion.toMap());
    }
    final response = await http.put(
        getUri('/api/v1/recoleccion-entrega/update/${recoleccion.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body
        //  body: jsonEncode(recoleccion.toMap()),
        );

    if (response.statusCode == 200) {
      dato = true;
    }
  } catch (e) {
    dato = false;
  }
  return dato;
}

Future<String> login(String username, String password) async {
  try {
    //Uri uri =     Uri.http(server, '/api/v1/auth/login');

    final response = await http.post(
      getUri('/api/v1/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 201) {
      return response.body;
    } else {
      return "";
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> dataUser(String token) async {
  try {
    final response = await http.get(
      getUri('/api/v1/auth/data-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  } catch (e) {
    return "";
  }
}

Future<bool> updateContrasena(String user, String password) async {
  bool dato = false;

//no se a asigando ningun empleado

  //String server = dotenv.env['SERVER'].toString();
  try {
    final response = await http.patch(getUri('/api/v1/usuario/updatepassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"username": user, "password": password})
        //  body: jsonEncode(recoleccion.toMap()),
        );

    if (response.statusCode == 200) {
      dato = true;
    }
  } catch (e) {
    dato = false;
  }
  return dato;
}
