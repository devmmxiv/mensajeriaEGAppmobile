import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/functions/format_functions.dart';
import 'package:mobile_app_mensajeria/functions/http_recoleccion.dart';
import 'package:mobile_app_mensajeria/models/cliente_recoleccion_entrega_model.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/pages/detalle_recoleccion_entrega.dart';
import 'package:mobile_app_mensajeria/pages/list_page.dart';
import 'package:mobile_app_mensajeria/pages/save_page.dart';
import 'package:mobile_app_mensajeria/pages/save_recoleccione_entrega.dart';
import 'package:mobile_app_mensajeria/widgets/items_recoleccion_entrega.dart';
import 'package:path/path.dart';

class RecoleccionesEntregasWidget extends StatefulWidget {
  const RecoleccionesEntregasWidget(
      {super.key,
      required this.recolecciones,
      required this.onChangeEstado,
      required this.titulo});
  final List<RecoleccionEntrega> recolecciones;
  final void Function() onChangeEstado;
  final String titulo;
  @override
  State<RecoleccionesEntregasWidget> createState() =>
      _RecoleccionesEntregasWidgetState();
}

class _RecoleccionesEntregasWidgetState
    extends State<RecoleccionesEntregasWidget> {
  late UserLogeado singleton = UserLogeado();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    String tituloBoton = '';

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
            backgroundColor: colors.primary,
            title: Text(widget.titulo,
                style: const TextStyle(
                    fontSize: 16, fontFamily: 'Lato', color: Colors.white))),
        body: ItemsRecoleccionesWidget(
            lista: widget.recolecciones,
            singleton: singleton,
            onChangeEstado: widget.onChangeEstado)

        /*  ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: widget.recolecciones.length,
          itemBuilder: (_, i) => _createItem( i, widget.recolecciones)),*/
        );
  }

  // ignore: non_constant_identifier_names
  Widget Tarjeta(RecoleccionEntrega r, Function onChangeEstado) {
    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (singleton.perfilUsuario == 'EMPLEADO') ...[],
          ],
        ),
        onTap: () {
          if (r.estado.toLowerCase() == 'entregada' ||
              r.estado.toLowerCase() == 'no_recibida' ||
              r.estado.toLowerCase() == 'creada') {
          } else {
            Navigator.push(
                this.context,
                MaterialPageRoute(
                    builder: (context) => DetalleRecoleccionEntregaWidget(
                          recoleccion: r, //, recolecciones[i],
                          onChangeEstado: () {
                            // setState(() {
                            // _loadData();
                            //});
                          },
                        ))).then((value) => setState(() {}));
          }
        },
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Persona Recibe',
              style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Row(children: [
              const Icon(Icons.person),
              Expanded(
                child: Text('${r.nombreRecibe} ${r.apellidoRecibe}',
                    style:
                        const TextStyle(fontFamily: 'Lato', fontSize: 18.00)),
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
                  r.municipioRecibe
                      .nombre!, // recolecciones[i].municipioRecibe,
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
                        style: const TextStyle(
                            fontFamily: 'Lato', fontSize: 18.00)),
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
                        style: const TextStyle(
                            fontFamily: 'Lato', fontSize: 18.00)),
                  ),
                ],
              ),
              //]
            ],
            if (r.estado.toLowerCase() == "creada" &&
                singleton.perfilUsuario == "EMPLEADO") ...[
              OutlinedButton(
                child: const Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Marcar como recolectada ")])
                  ],
                ),
                onPressed: () async {
                  if (await respuesta(this.context, 'Pregunta',
                      'Seguro ya recolecto el paquete', false)) {
                    updateEstadoRecoleccion(r.id, 'recolectada');
                  }
                },
              ),
            ]
          ],
        ),
        trailing: Column(
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
                      Navigator.pushNamed(
                              this.context, SaveRecoleccionEntrega.ROUTE,
                              arguments: [r, onChangeEstado()])
                          .then((value) => setState(() {}));
                    }
                  },
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  Future<bool> respuestaL(title, String mensaje) async {
    bool? dato = (await showBackDialog(this.context, title, mensaje)) ?? false;
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
