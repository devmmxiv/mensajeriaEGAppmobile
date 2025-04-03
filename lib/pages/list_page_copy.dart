import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/db/operation_db.dart';
import 'package:mobile_app_mensajeria/functions/format_functions.dart';
import 'package:mobile_app_mensajeria/functions/http_functions.dart';
import 'package:mobile_app_mensajeria/models/municpios_model.dart';
import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';
import 'package:mobile_app_mensajeria/pages/detalle_list.dart';
import 'package:mobile_app_mensajeria/pages/save_page.dart';

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
  late Future<List<Recoleccion>> recolecciones;
  bool isInternet = true;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  _loadData() async {
    if (isInternet) {
      recolecciones = getRecoleccionesHttp();
    } else {
    //  recolecciones = Operation.instance.getRecolecciones();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
        Municipio(id: 1, nombre: ""),
        Cliente(id: 0, nombre: '', apellido: '', telefono: '', direcciones: []),
        Empleado(id: 0, nombre: '', apellido: '', telefono: ''));

    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, SavePage.ROUTE, arguments: r)
                    .then((_) => setState(() {
                          _loadData();
                        }));
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: colors.primary,
              title: const Text(
                "Listado de Recolecciones",
                style: TextStyle(
                  fontFamily: 'lato',
                  color: Colors.white,
                ),
              ),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.local_shipping_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.done_all),
                  ),
                ],
              ),
            ),
            body: FutureBuilder(
                future: recolecciones,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Recoleccion> temp = snapshot.data!;
                    List<Recoleccion> temp1 = [];
                    List<Recoleccion> temp2 = [];
                    for (var e in temp) {
                      if (e.estado.toLowerCase() == 'entregada') {
                        temp2.add(e);
                      } else {
                        temp1.add(e);
                      }
                    }

                    return TabBarView(
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Paquetes en Ruta",
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w600),
                            ),
                            Expanded(child: listViewRecolecciones(temp1)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Paquetes Entregados",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
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

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                          padding: const EdgeInsets.all(20),
                          onPressed: () {
                            setState(() {
                              _loadData();
                            });
                          },
                          child: const Text("Presione para Trabajar Offline"),
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }

  Widget listViewRecolecciones(List<Recoleccion> lista) {
    return ListView.builder(
        padding: const EdgeInsets.all(5),
        itemCount: lista.length,
        itemBuilder: (_, i) => _createItem(i, lista));
    //_createItem(i, lista));
  }

  _createItem(int i, List<Recoleccion> lista) {
    return Dismissible(
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
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            int a = await Operation.instance.deleteRecoleccion(lista[i]);
            if (a > 0) {
              //recolecciones.removeAt(i);
            }
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Row(
              children: [
                const Icon(Icons.person),
                Expanded(
                  child: Text(
                      '${lista[i].nombreRecibe} ${lista[i].apellidoRecibe}',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 18.00)),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetalleListWidget(
                            recoleccion: lista[i], //, recolecciones[i],
                            onChangeEstado: () {
                              setState(() {
                                _loadData();
                              });
                            },
                          ))).then((value) => setState(() {
                    _loadData();
                  }));
            },
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on),
                    Expanded(
                        child: Text(
                      lista[i]
                          .direccionEntrega, //   recolecciones[i].direccionEntrega,
                      style: const TextStyle(fontSize: 16),
                    )),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_city),
                    Expanded(
                        child: Text(
                      lista[i]
                          .municipioRecibe
                          .nombre!, // recolecciones[i].municipioRecibe,
                      style: const TextStyle(fontSize: 16),
                    )),
                  ],
                ),
                Row(
                  children: [
                    if (lista[i].tipoPago.toUpperCase() == "EFECTIVO") ...[
                      const Icon(Icons.paid),
                    ] else if (lista[i].tipoPago.toUpperCase() ==
                        "TARJETA") ...[
                      const Icon(Icons.credit_card),
                    ] else if (lista[i].tipoPago.toUpperCase() ==
                        "TRANSFERENCIA") ...[
                      const Icon(Icons.account_balance),
                    ] else ...[
                      const Icon(Icons.block),
                    ],
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: formaterNumber(lista[i].totalCobrar),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
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
                      lista[i].telefonoRecibe,
                      style: const TextStyle(fontSize: 16),
                    )),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.date_range_outlined),
                    Expanded(
                      child: Text(
                        formatoFecha(lista[i].fechaCreacion),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined),
                    Expanded(
                      child: Text(
                        lista[i].estado,
                        style: styleEstado(lista[i].estado),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (lista[i].estado.toLowerCase() != 'entregada') ...[
                  Expanded(
                    flex: 1,
                    child: MaterialButton(
                      child: const Icon(Icons.edit),
                      onPressed: () {
                        if (lista[i].estado.toLowerCase() != 'entregada') {
                          Navigator.pushNamed(context, SavePage.ROUTE,
                                  arguments: lista[i])
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
        ));
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
