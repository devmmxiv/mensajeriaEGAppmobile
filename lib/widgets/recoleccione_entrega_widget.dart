import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/models/cliente_recoleccion_entrega_model.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/widgets/items_recoleccion_entrega.dart';

class RecoleccioneEntregaWidget extends StatelessWidget {
  const RecoleccioneEntregaWidget(
      {super.key, required this.clientesRecoleccion, required this.estado,required this.onChangeEstado});
  final List<ClienteRecoleccionEntrega> clientesRecoleccion;
  final String estado;
  final void Function() onChangeEstado;
  @override
  Widget build(BuildContext context) {
    return listviewClienteRecoleccionEntrega(clientesRecoleccion);
  }

  Widget listviewClienteRecoleccionEntrega(
      List<ClienteRecoleccionEntrega> lista) {
    UserLogeado singleton = UserLogeado();
    List<RecoleccionEntrega> l = [];
    for (var e in lista) {
      for (var r in e.recolecciones!) {
        if (estado.toLowerCase() == "entregada") {
          if (r.estado.toLowerCase() == estado.toLowerCase() ||
              r.estado.toLowerCase() == "no_recibida") {
            l.add(r);
          }
        } else {
          if (r.estado.toLowerCase() == estado.toLowerCase()) {
            l.add(r);
          }
        }
      }
    }
    l.sort((a, b) => a.nombreRecibe.compareTo(b.nombreRecibe));
    return ItemsRecoleccionesWidget(lista: l, singleton: singleton,onChangeEstado:onChangeEstado);
  }


}
