import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/functions/format_functions.dart';
import 'package:mobile_app_mensajeria/functions/http_recoleccion.dart';
import 'package:mobile_app_mensajeria/models/cliente_recoleccion_entrega_model.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/pages/save_page.dart';
import 'package:mobile_app_mensajeria/pages/save_recoleccione_entrega.dart';

class ItemsRecoleccionesWidget extends StatelessWidget {
  const ItemsRecoleccionesWidget({
    super.key,
    required this.lista,
    required this.singleton,
    required this.onChangeEstado,
  });
  final List<RecoleccionEntrega> lista;
  final UserLogeado singleton;

  final void Function() onChangeEstado;

  @override
  Widget build(BuildContext context) {
    return ItemsBuilder(context);
  }

  // ignore: non_constant_identifier_names
  Widget ItemsBuilder(BuildContext context) {
    return
        // Text('${lista.length.toString()} Paquetes en Ruta'),
        ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: lista.length,
            itemBuilder: (_, i) =>
                createItem(context, i, lista, onChangeEstado));
  }

  Widget createItem(BuildContext context, int i, List<RecoleccionEntrega> lista,
      Function onChange) {
    if (singleton.perfilUsuario == "ADMINISTRADOR" ||
        (lista[i].estado == "CREADA" && singleton.perfilUsuario == "CLIENTE")) {
      return Dismissible(
          confirmDismiss: (DismissDirection dismissDirection) async {
            switch (dismissDirection) {
              case DismissDirection.startToEnd:
                return await respuestaL(
                    context, 'Pregunta', 'Seguro desea Eliminar el Registro');

              case DismissDirection.horizontal:
              case DismissDirection.vertical:
              case DismissDirection.up:
              case DismissDirection.down:
              case DismissDirection.endToStart:
                assert(false);
              case DismissDirection.none:
              // TODO: Handle this case.
            }

            return null;
          },
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.only(left: 10),
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
          ),
          direction: lista[i].estado.toLowerCase() == 'entregada'
              ? DismissDirection.none
              : DismissDirection.startToEnd,
          onDismissed: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              /* int a = await Operation.instance.deleteRecoleccion(lista[i]);
              if (a > 0) {
                //recolecciones.removeAt(i);
              }*/
            }
          },
          child: Tarjeta(context, lista[i], i, lista.length, onChange));
    } else {
      return Tarjeta(context, lista[i], i + 1, lista.length, onChange);
    }
    // }
  }

  // ignore: non_constant_identifier_names
  Widget Tarjeta(BuildContext context, RecoleccionEntrega r, int index,
      int tamanio, Function onChange) {
    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index.toString()}/${tamanio.toString()}',
                style: const TextStyle(
                    fontFamily: 'Lato',
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.normal))
          ],
        ),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Persona Recibe',
            style: TextStyle(
                fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(children: [
            const Icon(Icons.person),
            Expanded(
              child: Text('${r.nombreRecibe} ${r.apellidoRecibe}',
                  style: const TextStyle(fontFamily: 'Lato', fontSize: 18.00)),
            ),
          ]),
          Row(
            children: [
              if (r.estado.toLowerCase() == 'recolectada') ...[
                const Icon(Icons.location_on),
                Expanded(
                    child: Text(
                  r.direccionEntrega, //   recolecciones[i].direccionEntrega,
                  style: const TextStyle(fontSize: 16),
                )),
              ],
            ],
          ),
          Row(
            children: [
              const Icon(Icons.location_city),
              Expanded(
                  child: Text(
                r.municipioRecibe.nombre!, // recolecciones[i].municipioRecibe,
                style: const TextStyle(fontFamily: 'Lato', fontSize: 16),
              )),
            ],
          ),
          Row(
            children: [
              if (r.tipoPago.toUpperCase() == "EFECTIVO") ...[
                const Icon(Icons.paid),
              ] else if (r.tipoPago.toUpperCase() == "TARJETA") ...[
                const Icon(Icons.credit_card),
              ] else if (r.tipoPago.toUpperCase() == "TRANSFERENCIA") ...[
                const Icon(Icons.account_balance),
              ] else ...[
                const Icon(Icons.block),
              ],
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: formaterNumber(r.totalCobrar),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  )
                ]),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.phone_android_outlined),
              Expanded(
                  child: Text(
                r.telefonoRecibe,
                style: const TextStyle(fontSize: 16),
              )),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.date_range_outlined),
              Expanded(
                child: Text(
                  formatoFecha(r.fechaCreacion),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          /*  Row(
              children: [
                const Icon(Icons.local_shipping_outlined),
                Expanded(
                  child: Text(
                    r.estado,
                    style: styleEstado(r.estado),
                  ),
                ),
              ],
            ),*/

          if (r.empleadoAsignado!.id != null) ...[
            //if (singleton.perfilUsuario == 'EMPLEADO') ...[
            const SizedBox(height: 10),
            const Text(
              'Mensajero Asignado',
              style: TextStyle(
                  fontFamily: 'Lato',
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.two_wheeler_outlined),
                Expanded(
                  child: Text(
                      '${r.empleadoAsignado!.nombre} ${r.empleadoAsignado!.apellido}',
                      style:
                          const TextStyle(fontFamily: 'Lato', fontSize: 18.00)),
                ),
              ],
            ),
            //]
          ],
          if (r.estado.toLowerCase() == "entregada" ||
              r.estado.toLowerCase() == "no_recibida") ...[
            //if (singleton.perfilUsuario == 'EMPLEADO') ...[
            const SizedBox(height: 10),
            const Text(
              'Estado',
              style: TextStyle(
                  fontFamily: 'Lato',
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                //const Icon(Icons.prodct),
                Expanded(
                  child: Text(r.estado,
                      style:
                          const TextStyle(fontFamily: 'Lato', fontSize: 18.00)),
                ),
              ],
            ),
            //]
          ],
          if (r.estado.toLowerCase() == "en_ruta") ...[
            SizedBox(
                width: 50,
                child: OutlinedButton(
                  child: const Text("Marcar como entregada"),
                  onPressed: () async {
                    if (await respuesta(context, 'Pregunta',
                        'Seguro ya Entrego el paquete', false)) {
                      updateEstadoRecoleccion(r.id, 'entregada');
                    }
                  },
                )),
          ] else if (r.estado.toLowerCase() == "creada" &&
              singleton.perfilUsuario != "CLIENTE") ...[
            OutlinedButton(
              child: const Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Marcar como recolectada ")])
                ],
              ),
              onPressed: () async {
                if (await respuesta(context, 'Pregunta',
                    'Seguro ya recolecto el paquete', false)) {
                  updateEstadoRecoleccion(r.id, 'recolectada');
                }
              },
            )
          ],
          if (singleton.perfilUsuario == "EMPLEADO" &&
              !singleton.isAdministrador)
            ...[]
          else if (r.estado.toLowerCase() != 'entregada') ...[
            OutlinedButton(
              child: const Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Modificar Datos")])
                ],
              ),
              onPressed: () async {
                if (r.estado.toLowerCase() == 'entregada' ||
                    r.estado.toLowerCase() == 'no_recibida') {
                } else {
                  Navigator.pushNamed(context, SaveRecoleccionEntrega.ROUTE,
                      arguments: {"recoleccion": r, "funcion": onChangeEstado});
                }
              },
            )
          ]
        ]),
        /*trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (singleton.perfilUsuario == "EMPLEADO" &&
                !singleton.isAdministrador)
              ...[]
            else if (r.estado.toLowerCase() != 'entregada') ...[
              Expanded(
                flex: 1,
                child: MaterialButton(
                  child: const Icon(Icons.edit),
                  onPressed: () {
                    if (r.estado.toLowerCase() == 'entregada' ||
                        r.estado.toLowerCase() == 'no_recibida') {
                    } else {
                      Navigator.pushNamed(context, SaveRecoleccionEntrega.ROUTE,
                          arguments: r);
                    }
                  },
                ),
              )
            ],
          ],
        ),*/
      ),
    );
  }

  Future<bool> respuestaL(BuildContext context, title, String mensaje) async {
    bool? dato = (await showBackDialog(context, title, mensaje)) ?? false;
    return dato;
  }

  Future<bool> respuesta(
      BuildContext contexto, title, String mensaje, bool confirm) async {
    bool? dato = false;
    if (confirm) {
      dato = (await showConfirmDialog(contexto, title, mensaje)) ?? true;
    } else {
      dato = (await showBackDialog(contexto, title, mensaje)) ?? false;
    }

    return dato;
  }

  Future<bool?> showConfirmDialog(
      BuildContext context, String title, String mensaje) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            mensaje,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showBackDialog(
      BuildContext context, String title, String mensaje) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            mensaje,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Si'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
