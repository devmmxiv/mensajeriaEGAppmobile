import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/api/api_recoleccion.dart';

import 'package:mobile_app_mensajeria/models/cliente_recoleccion_entrega_model.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/models/municpios_model.dart';
import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';
import 'package:mobile_app_mensajeria/pages/recolecciones_entregas.dart';

import 'package:mobile_app_mensajeria/pages/save_page.dart';
import 'package:mobile_app_mensajeria/pages/save_recoleccione_entrega.dart';
import 'package:mobile_app_mensajeria/widgets/recoleccione_entrega_widget.dart';

class ListPageTest extends StatelessWidget {
  const ListPageTest({super.key});
  // ignore: constant_identifier_names
  static const String ROUTE = '/list';

  @override
  Widget build(BuildContext context) {
    return _ListRecoleccionesEntregas();
  }
}

class _ListRecoleccionesEntregas extends StatefulWidget {
  @override
  State<_ListRecoleccionesEntregas> createState() => _ListRecoleccionesState();
}

class _ListRecoleccionesState extends State<_ListRecoleccionesEntregas> {
  late UserLogeado singleton;

  late Future<List<ClienteRecoleccionEntrega>> clientes;

  @override
  void initState() {
    super.initState();
    singleton = UserLogeado();
    _loadData();
  }

  Future<Null> _loadData() async {
    setState(() {
      clientes = getClienteRecoleccionesNocerradas(singleton);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    RecoleccionEntrega r = RecoleccionEntrega(
      0,
      DateTime.now().toString(),
      "",
      "",
      "",
      "0.00",
      "0.00",
      "",
      0,
      "CREADA",
      "EFECTIVO",
      // Municipio(id: 1, name: "", code: ""),
      Municipio(id: 1, nombre: ""),

      Empleado(id: 0, nombre: '', apellido: '', telefono: ''),
      ClienteInsert(
        id: 0,
      ),
    );
    // ": "5656533323",
    return Column(children: [
      if (singleton.perfilUsuario == "EMPLEADO" &&
          !singleton.isAdministrador) ...[
        Expanded(
            child: DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Scaffold(
                    //    floatingActionButton: BotonFlotante(r),
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
                        future: clientes,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<ClienteRecoleccionEntrega> temp =
                                snapshot.data!;
                            //  return (

                            return TabBarView(children: [
                              Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const Text(
                                      " Paquetes Por Recolectar",
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Expanded(
                                        child: listviewClienteRecoleccionEntrega(
                                            temp.cast<
                                                ClienteRecoleccionEntrega>())),
                                    //Expanded(child: listViewEncabezados())
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const Text(
                                      " Paquetes en Ruta",
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Expanded(
                                        child: RecoleccioneEntregaWidget(
                                      clientesRecoleccion: temp
                                          .cast<ClienteRecoleccionEntrega>(),
                                      estado: "recolectada",
                                      onChangeEstado: () {
                                        setState(() {
                                          _loadData();
                                        });
                                      },
                                    )),
                                    //Expanded(child: listViewEncabezados())
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const Text(
                                      " Paquetes entregados",
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Expanded(
                                        child: RecoleccioneEntregaWidget(
                                            clientesRecoleccion: temp.cast<
                                                ClienteRecoleccionEntrega>(),
                                            estado: "entregada",
                                            onChangeEstado: () {
                                              setState(() {
                                                _loadData();
                                              });
                                            })),
                                    //Expanded(child: listViewEncabezados())
                                  ],
                                ),
                              )
                            ]);

                            //]);
                          } else if (snapshot.hasError) {
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
                        }))))
      ] else ...[
        Expanded(
            child: Scaffold(
                floatingActionButton: BotonFlotante(r),
                body: FutureBuilder(
                    future: clientes,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<ClienteRecoleccionEntrega> temp = snapshot.data!;
                        //  return (

                        return Expanded(
                            child: listviewClienteRecoleccionEntrega(
                                temp.cast<ClienteRecoleccionEntrega>()));

                        //]);
                      } else if (snapshot.hasError) {
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
                    })))
      ]
    ]);
  }

  void funcion() {}

  // ignore: non_constant_identifier_names
  Widget BotonFlotante(RecoleccionEntrega r) {
    if (singleton.perfilUsuario == "EMPLEADO") {
      return Container();
    } else {
      return FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context, SaveRecoleccionEntrega.ROUTE, arguments: {
            "recoleccion": r
          }).then((_) => setState(() {
                _loadData();
              }));
        },
        child: const Icon(Icons.add),
      );
    }
  }

  // ignore: non_constant_identifier_names
  Widget listviewClienteRecoleccionEntrega(
      List<ClienteRecoleccionEntrega> lista) {
    return RefreshIndicator(
        key: UniqueKey(),
        onRefresh: _loadData,
        child: ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: lista.length,
            itemBuilder: (_, i) => _createItemClienteRecoleccion(i, lista)));
    //_createItem(i, lista));
  }

  _createItemClienteRecoleccion(int i, List<ClienteRecoleccionEntrega> lista) {
    if (singleton.perfilUsuario == "EMPLEADO" && !singleton.isAdministrador) {
      if (lista[i]
          .recolecciones!
          .where((t) => t.estado.toLowerCase() == "creada")
          .toList()
          .isEmpty) {
        return Container();
      } else {
        TarjetaClienteRecoleccion(lista[i]);
      }
    } else {
      return TarjetaClienteRecoleccion(lista[i]);
    }
  }

  // ignore: non_constant_identifier_names
  Widget TarjetaClienteRecoleccion(ClienteRecoleccionEntrega r) {

    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informacion del Cliente',
              style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Row(children: [
              const Icon(Icons.person),
              //const Text('Persona Envia'),
              Expanded(
                child: Text('${r.nombre} ${r.apellido}',
                    style:
                        const TextStyle(fontFamily: 'Lato', fontSize: 18.00)),
              ),
            ]),
            Row(children: [
              Expanded(
                child: Text(
                    'Direccion: ${r.direcciones![0].direccionCompleta} zona ${r.direcciones![0].zona} \n Municipio ${r.direcciones![0].municipio.nombre}',
                    style:
                        const TextStyle(fontFamily: 'Lato', fontSize: 18.00)),
              ),
            ]),
            const SizedBox(height: 10),
            OutlinedButton(
              child: Column(
                children: [
                  Row(children: [
                    const Icon(Icons.check),
                    const SizedBox(width: 5),
                    Text(
                        'Cantidad por Recolectar   ${r.recolecciones!.where((i) => i.estado.toLowerCase() == "creada").toList().length}')
                  ])
                ],
              ),
              onPressed: () {
                if (r.recolecciones!
                    .where((i) => i.estado.toLowerCase() == "creada")
                    .toList()
                    .isNotEmpty) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecoleccionesEntregasWidget(
                                recolecciones: r.recolecciones!
                                    .where((i) =>
                                        i.estado.toLowerCase() == "creada")
                                    .toList(), //, recolecciones[i],
                                onChangeEstado: () => {
                                  setState(() {
                                    _loadData();
                                  })
                                },
                                titulo: "Listado de Recolecciones",
                              ))).then((value) => setState(() {
                        _loadData();
                      }));
                }
              },
            ),
            const SizedBox(height: 10),
            if (singleton.perfilUsuario != "EMPLEADO" ||
                singleton.isAdministrador) ...[
              OutlinedButton(
                child: Column(
                  children: [
                    Row(children: [
                      const Icon(Icons.send),
                      const SizedBox(width: 5),
                      Text(
                          "Por Entregar  ${r.recolecciones!.where((i) => i.estado.toLowerCase() == "en_ruta" || i.estado.toLowerCase() == "recolectada").toList().length}")
                    ])
                  ],
                ),
                onPressed: () {
                  if (r.recolecciones!
                      .where((i) =>
                          i.estado.toLowerCase() == "en_ruta" ||
                          i.estado.toLowerCase() == "recolectada")
                      .toList()
                      .isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecoleccionesEntregasWidget(
                                  recolecciones: r.recolecciones!
                                      .where((i) =>
                                          i.estado.toLowerCase() == "en_ruta" ||
                                          i.estado.toLowerCase() ==
                                              "recolectada")
                                      .toList(), //, recolecciones[i],
                                  onChangeEstado: () {},
                                  titulo: "Listado de paquetes por Entregar",
                                ))).then((value) => setState(() {
                          _loadData();
                        }));
                  }
                },
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                child: Column(
                  children: [
                    Row(children: [
                      const Icon(Icons.check),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                          "Entregadas ${r.recolecciones!.where((i) => i.estado.toLowerCase() == "entregada" || i.estado.toLowerCase() == "no_recibida").toList().length}")
                    ])
                  ],
                ),
                onPressed: () {
                  if (r.recolecciones!
                      .where((i) =>
                          i.estado.toLowerCase() == "entregada" ||
                          i.estado.toLowerCase() == "no_recibida")
                      .toList()
                      .isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecoleccionesEntregasWidget(
                                  recolecciones: r.recolecciones!
                                      .where((i) =>
                                          i.estado.toLowerCase() ==
                                              "entregada" ||
                                          i.estado.toLowerCase() ==
                                              "no_recibida")
                                      .toList(), //, recolecciones[i],
                                  onChangeEstado: () {
                                    // setState(() {
                                    // _loadData();
                                    //});
                                  },
                                  titulo: "Entregadas / No Recibidas",
                                ))).then((value) => setState(() {
                          _loadData();
                        }));
                  }
                },
              )
            ]
          ],
        ),
      ),
    );
  }

  ///
}
