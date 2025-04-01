import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';

class ListaRecoleccionesView extends StatefulWidget {
  const ListaRecoleccionesView({
    super.key,
  });

  @override
  State<ListaRecoleccionesView> createState() => _ListaRecoleccionesViewState();
}

class _ListaRecoleccionesViewState extends State<ListaRecoleccionesView> {
  late Future<List<Recoleccion>> _listaRecolecciones;

  Future<List<Recoleccion>> _getRecolecciones() async {
    List<Recoleccion> recolecciones = [];

    try {
      Uri uri = Uri.http('192.168.0.5:8000', '/api/v1/recoleccion-entrega/');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);

        final jsonData = jsonDecode(body);

        for (var d in jsonData) {
          Recoleccion r = Recoleccion.fromJson(d);
          recolecciones.add((r));
         /* recolecciones.add(Recoleccion(
              d["id"],
              d["fechaCreacion"],
              d["nombreRecibe"],
              d["apellidoRecibe"],
              d["telefonoRecibe"],
              d["precioProducto"],
              d["direccionEntrega"],
              d["estado"],
              d["tipoPago"],
              d["municipioRecibe"]["id"],
              d["municipioRecibe"]["nombre"],
              d["idClienteEnvia"],
              d["municipioRecibe"]));*/
        }
      }
    } catch (e) {
      rethrow;
    }

    return recolecciones;
  }

  @override
  void initState() {
    super.initState();
    _listaRecolecciones = _getRecolecciones();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _listaRecolecciones,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //return //ListViewRecolecciones(lista: snapshot.data!);
          } else if (snapshot.hasError) {
            return const Text("Error en Lista de Recolecciones");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
