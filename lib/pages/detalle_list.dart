import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/functions/http_recoleccion.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';
import 'package:mobile_app_mensajeria/pages/list_page.dart';
import 'package:mobile_app_mensajeria/pages/show_message_page.dart';

class DetalleListWidget extends StatelessWidget {
  const DetalleListWidget(
      {super.key, required this.recoleccion, required this.onChangeEstado});
  final Recoleccion recoleccion;
  final void Function() onChangeEstado;

  @override
  Widget build(BuildContext context) {
    late UserLogeado singleton = UserLogeado();

    final colors = Theme.of(context).colorScheme;
    String tituloBoton = '';

    if (recoleccion.estado.toLowerCase() == 'entregada') {
      tituloBoton = 'La recoleccion ya ha sido entregada';
    } else if (recoleccion.estado.toLowerCase() == 'creada') {
      tituloBoton = 'Presione para Marcar como recolectada';
    } else {
      tituloBoton = 'Presione para Marcar como entregado';
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: colors.primary,
        title: TituloDetalle(recoleccion.estado),
      ),
      body: ListViewDetalle(recoleccion, tituloBoton, context, singleton),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ListViewDetalle(Recoleccion recoleccion, String tituloBoton,
      BuildContext context, UserLogeado singleton) {
    if (recoleccion.estado.toLowerCase() == 'entregada') {
      return Container();
    } else {
      return ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          CardNombre(recoleccion),
          const SizedBox(
            height: 10,
          ),
          CardDireccion(recoleccion),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          CardTelefono(recoleccion,singleton),
          const SizedBox(
            height: 10,
          ),
          CardFormaPago(recoleccion),
          const SizedBox(
            height: 10,
          ),
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Row(children: [
              const SizedBox(
                child: Icon(
                  Icons.date_range_outlined,
                  size: 40,
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Fecha de Creacion'),
                      Text(recoleccion.fechaCreacion,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 20.00)),
                    ],
                  ),
                ),
              )
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
          if (singleton.perfilUsuario != "CLIENTE") ...[
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: Row(children: [
                if (recoleccion.estado != 'entregada') ...[
                  const SizedBox(
                    child: Icon(
                      Icons.settings_power_sharp,
                      size: 40,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(
                              child: Text(tituloBoton),
                              onPressed: () async {
                                if (recoleccion.estado.toLowerCase() ==
                                    'entregada') {
                                  respuesta(
                                      context,
                                      'Confirmacion',
                                      'La Recoleccion ya esta marcada com Entregada, no se puede cambiar el estado.',
                                      true);
                                  return;
                                }
                                if (recoleccion.estado.toLowerCase() ==
                                    'creada') {
                                  if (await respuesta(
                                      context,
                                      'Pregunta',
                                      'Seguro ya recolecto el paquete',
                                      false)) {
                                    updateEstadoRecoleccion(
                                        recoleccion.id, 'recolectada');
                                   if (context.mounted) {
                                      Navigator.pop(
                                        context,
                                        ListPage.ROUTE,
                                      );
                                    }
                                   /* Operation.instance
                                      .updateEstado(
                                          'recolectada', recoleccion.id)
                                      .then((x) => {
                                            if (x == 1) {onChangeEstado()}
                                          });*/
                                  }
                                } else {
                                  if (await respuesta(context, 'Pregunta',
                                      'Seguro ya entrego el paquete', false)) {
                                    updateEstadoRecoleccion(
                                        recoleccion.id, 'entregada');
                                    if (context.mounted) {
                                      Navigator.pop(
                                        context,
                                        ListPage.ROUTE,
                                      );
                                    }
                                    /* Operation.instance
                                      .updateEstado('entregada', recoleccion.id)
                                      .then((x) => {
                                            if (x == 1) {onChangeEstado()}
                                          });*/
                                  }
                                }
                              },
                            )
                          ]),
                    ),
                  )
                ],
              ]),
            )
          ],
        ],
      );
    }
  }

  // ignore: non_constant_identifier_names
  Widget TituloDetalle(String estado) {
    if (estado.toLowerCase() == 'creada') {
      return (const Text("Datos para Recoleccion",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)));
    } else if (estado.toLowerCase() == 'recolectada') {
      return (const Text("Datos Persona que Recibe",
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Lato',
              color: Colors.white,
              fontWeight: FontWeight.bold)));
    } else {
      return (const Text("Detalle de paquete Recolectado",
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Lato',
              color: Colors.white,
              fontWeight: FontWeight.bold)));
    }
  }

  // ignore: non_constant_identifier_names
  Widget CardNombre(Recoleccion recoleccion) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Row(children: [
        const SizedBox(
          child: Icon(
            Icons.person,
            size: 40,
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Datos Personales'),
                if (recoleccion.estado.toLowerCase() == 'creada') ...[
                  Text(recoleccion.clienteEnvia.nombre!,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 24.00)),
                  Text(recoleccion.clienteEnvia.apellido!,
                      style: const TextStyle(
                          decorationStyle: TextDecorationStyle.dotted,
                          fontStyle: FontStyle.italic,
                          fontSize: 18.00)),
                ] else ...[
                  //recibe
                  Text(recoleccion.nombreRecibe,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 24.00)),
                  Text(recoleccion.apellidoRecibe,
                      style: const TextStyle(
                          decorationStyle: TextDecorationStyle.dotted,
                          fontStyle: FontStyle.italic,
                          fontSize: 18.00)),
                ],
              ],
            ),
          ),
        )
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CardDireccion(Recoleccion recoleccion) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Row(children: [
        const SizedBox(
          child: Icon(
            Icons.location_city_outlined,
            size: 40,
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Direccion'),
                if (recoleccion.estado.toLowerCase() == 'creada') ...[
                  Text(
                      recoleccion
                          .clienteEnvia.direcciones[0].direccionCompleta!,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 24.00)),
                  Text("Zona ${recoleccion.clienteEnvia.direcciones[0].zona!}",
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 24.00)),
                  Text(
                      recoleccion.clienteEnvia.direcciones[0].municipio.nombre!,
                      style: const TextStyle(
                          decorationStyle: TextDecorationStyle.dotted,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.00)),
                ] else ...[
                  //recibe
                  Text(recoleccion.direccionEntrega,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 24.00)),

                  Text(recoleccion.municipioRecibe.nombre!,
                      style: const TextStyle(
                          decorationStyle: TextDecorationStyle.dotted,
                          fontStyle: FontStyle.italic,
                          fontSize: 18.00)),
                ],
              ],
            ),
          ),
        )
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CardTelefono(Recoleccion recoleccion,UserLogeado singleton) {

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Row(children: [
        const SizedBox(
          child: Icon(
            Icons.phone_android_outlined,
            size: 40,
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Numero de Telefono'),
                if (singleton.perfilUsuario!="EMPLEADO") ...[
                  Text(recoleccion.telefonoRecibe,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 24.00))
                ] 
              ],
            ),
          ),
        )
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CardFormaPago(Recoleccion recoleccion) {

    if (recoleccion.estado.toLowerCase() == 'recolectada') {
      return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Row(children: [
          const SizedBox(
            child: Icon(
              Icons.money_off_outlined,
              size: 40,
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Forma de Pago'),
                  Text(recoleccion.tipoPago.toUpperCase(),
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 20.00)),
                  Text(recoleccion.totalCobrar,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 20.00)),
                ],
              ),
            ),
          )
        ]),
      );
    } else {
      return Container();
    }
  }
}
