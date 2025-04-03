import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/api/api_recoleccion.dart';
import 'package:mobile_app_mensajeria/functions/format_functions.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/models/municpios_model.dart';
import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';
import 'package:mobile_app_mensajeria/pages/detalle_list.dart';
import 'package:mobile_app_mensajeria/pages/save_page.dart';
import 'package:mobile_app_mensajeria/pages/show_message_page.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});
  // ignore: constant_identifier_names
  static const String ROUTE = '/list';

  @override
  Widget build(BuildContext context) {
    return _ListRecolecciones();
  }
}

class _ListRecolecciones extends StatefulWidget {
  @override
  State<_ListRecolecciones> createState() => _ListRecoleccionesState();
}

class _ListRecoleccionesState extends State<_ListRecolecciones> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  late UserLogeado singleton;
  late Future<List<Recoleccion>> recolecciones;
  bool isInternet = true;

  @override
  void initState() {
    super.initState();
    singleton = UserLogeado();

    _loadData();
  }

  Future<Null> _loadData() async {
    refreshKey.currentState?.show();
    setState(() {
      recolecciones = getRecolecciones(singleton);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Recoleccion r = Recoleccion(
       0,
        DateTime.now().toString(),
         "",
       "",
         "",
         "0.00",
         "0.00",
         "",
         0,
         "creada",
         "efectivo",
        // Municipio(id: 1, name: "", code: ""),
          Municipio(id: 1, nombre: ""),
          Cliente(id: 0, nombre: '', apellido: '', telefono: '', direcciones: []),
          Empleado(id: 0, nombre: '', apellido: '', telefono: ''));
    // ": "5656533323",

    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
            floatingActionButton: BotonFlotante(r),
            appBar: AppBar(
              backgroundColor: Colors.yellow[600],
              title: const TabBar(
                indicatorColor: Colors.black,
                tabs: <Widget>[
                  Tab(
                      key: Key("1"),
                      icon: Icon(
                        Icons.house_sharp,
                        color: Colors.black,
                      )),
                  Tab(
                    key: Key("2"),
                    icon: Icon(
                      Icons.motorcycle_outlined,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    key: Key("3"),
                    icon: Icon(
                      Icons.assignment_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            body: FutureBuilder(
                future: recolecciones,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Recoleccion> temp = snapshot.data!;
                    List<Recoleccion> temp0 = [];
                    List<Recoleccion> temp1 = [];
                    List<Recoleccion> temp2 = [];
                    try {
                      for (var e in temp) {
                        if (e.estado.toLowerCase() == 'entregada') {
                          temp2.add(e);
                        } else if (e.estado.toLowerCase() == 'creada') {
                          temp0.add(e);
                        } else {
                          temp1.add(e);
                        }
                      }
                      // ignore: empty_catches
                    } catch (e) {}

                    return TabBarView(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const Text(
                                "Paquetes por Recolectar",
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(child: listViewRecolecciones(temp0)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Text(
                              "Paquetes en Ruta",
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(child: listViewRecolecciones(temp1)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Paquetes Entregados",
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(child: listViewRecolecciones(temp2)),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    isInternet = false;
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //return const Text("Error en Lista de Recolecciones");

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _loadData();
                              });
                            },
                            child: const Text(
                              "Intente de Nuevo",
                              style: TextStyle(
                                fontFamily: 'Lato',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }

  Widget listViewRecolecciones(List<Recoleccion> lista) {
    return RefreshIndicator(
        key: refreshKey,
        onRefresh: _loadData,
        child: ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: lista.length,
            itemBuilder: (_, i) => _createItem(i, lista)));
    //_createItem(i, lista));
  }

  _createItem(int i, List<Recoleccion> lista) {
    if (UserLogeado().perfilUsuario == "EMPLEADO" &&
        !UserLogeado().isAdministrador) {
      //return Container();

      return Tarjeta(lista[i]);
    } else {
      return Dismissible(
          confirmDismiss: (DismissDirection dismissDirection) async {
            switch (dismissDirection) {
              case DismissDirection.startToEnd:
                return await respuesta(
                    'Pregunta', 'Seguro desea Eliminar el Registro');

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
          child: Tarjeta(lista[i]));
    }
  }

  Future<bool> respuesta(title, String mensaje) async {
    bool? dato = (await showBackDialog(context, title, mensaje)) ?? false;
    return dato;
  }

  // ignore: non_constant_identifier_names
  Widget Tarjeta(Recoleccion r) {
    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (singleton.perfilUsuario == 'EMPLEADO') ...[
              const Text(
                'Cliente Envia',
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Row(children: [
                const Icon(Icons.person),
                //const Text('Persona Envia'),
                Expanded(
                  child: Text(
                      '${r.clienteEnvia.nombre} ${r.clienteEnvia.apellido}',
                      style:
                          const TextStyle(fontFamily: 'Lato', fontSize: 18.00)),
                ),
              ]),
              Fila(
                  r.estado,
                  r.clienteEnvia.direcciones.first.direccionCompleta!,
                  const Icon(Icons.location_on)),
              Fila(r.estado, r.clienteEnvia.direcciones.first.municipio.nombre!,
                  const Icon(Icons.check)),
              const SizedBox(height: 10)
            ],
          ],
        ),
        onTap: () {
          if (r.estado.toLowerCase() == 'entregada') {
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetalleListWidget(
                          recoleccion: r, //, recolecciones[i],
                          onChangeEstado: () {
                            setState(() {
                              _loadData();
                            });
                          },
                        ))).then((value) => setState(() {
                  _loadData();
                }));
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
                    if (r.estado.toLowerCase() != 'entregada') {
                      Navigator.pushNamed(context, SavePage.ROUTE, arguments: r)
                          .then((value) => setState(() {
                                _loadData();
                              }));
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

  // ignore: non_constant_identifier_names
  Widget BotonFlotante(Recoleccion r) {
    if (singleton.perfilUsuario == "EMPLEADO") {

   
return Container();
     
      
    } else {
      return FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SavePage.ROUTE, arguments: r)
              .then((_) => setState(() {
                    _loadData();
                  }));
        },
        child: const Icon(Icons.add),
      );
    }
  }

  // ignore: non_constant_identifier_names
  Widget Fila(String estado, String texto, Icon icon) {
    if (estado.toLowerCase() == 'entregada') {
      return Container();
    } else {
      return Row(children: [
        icon,
        //const Text('Persona Envia'),
        Expanded(
          child: Text(texto,
              style: const TextStyle(fontFamily: 'Lato', fontSize: 18.00)),
        ),
      ]);
    }
  }

  TextStyle styleEstado(String estado) {
    Color color = Colors.green;

    double fontSize = 18;
    if (estado.toUpperCase() == 'CREDA') {
      color = const Color.fromARGB(255, 240, 139, 7);
    } else if (estado.toUpperCase() == 'RECOLECTADA') {
      color = Colors.black;
    } else if (estado == 'ENRUTA') {
      color = Colors.green;
    } else if (estado.toUpperCase() == 'ENTREGADA') {
      color = Colors.green;
    } else {
      color = Colors.blue;
    }
    return TextStyle(fontSize: fontSize, color: color);
  }
}
