// ignore_for_file: empty_catches

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:mobile_app_mensajeria/enums/tipo_pago_enum.dart';
import 'package:mobile_app_mensajeria/functions/http_functions.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/models/municpios_model.dart';

import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';
import 'package:mobile_app_mensajeria/pages/list_page.dart';
import 'package:mobile_app_mensajeria/pages/show_message_page.dart';

import 'package:mobile_app_mensajeria/widgets/municipio_widget.dart';
import 'package:mobile_app_mensajeria/widgets/tipopago_widget.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  // ignore: constant_identifier_names
  static const String ROUTE = "/page";

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  final nombreRecibeController = TextEditingController();
  final apellidoRecibeController = TextEditingController();
  final telefonoRecibeController = TextEditingController();
  final precioProductoController = TextEditingController();
  final zonaRecibeController = TextEditingController();
  final direccionController = TextEditingController();
  final estadoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<ScaffoldState>();
  String tipopagoValue = "";
  TipoPago t = TipoPago.EFECTIVO;
  Future<Recoleccion>? _futureRecoleccion;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Recoleccion? recoleccion =
        ModalRoute.of(context)!.settings.arguments as Recoleccion?;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await Respuesta(
            'Pregunta', 'Seguro desea regresar sin guardar los cambios?');
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          key: _scafoldKey,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            elevation: 0,
            backgroundColor: colors.primary,
            title: const Text(
              "Formulario de Recoleccion",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Lato'),
            ),
          ),
          body: (_futureRecoleccion == null)
              ? _buildForm(recoleccion!)
              : buildRecoleccionFutureBuilder(), //_buildForm(recoleccion!),
        ),
      ),
    );
  }

  _init(Recoleccion recoleccion) {
    //print(recoleccion.toMap());

    if (recoleccion.id > 0) {
      nombreRecibeController.text = recoleccion.nombreRecibe;
      apellidoRecibeController.text = recoleccion.apellidoRecibe;
      telefonoRecibeController.text = recoleccion.telefonoRecibe;
      direccionController.text = recoleccion.direccionEntrega;
      precioProductoController.text = recoleccion.totalCobrar;
      zonaRecibeController.text = recoleccion.zonaEntrega.toString();
    }
    UserLogeado user = UserLogeado();
    if (user.perfilUsuario == "CLIENTE") {
      recoleccion.clienteEnvia.id = user.id;
    }

    if (TipoPago.EFECTIVO.name == recoleccion.tipoPago.toUpperCase()) {
      t = TipoPago.EFECTIVO;
    } else if (recoleccion.tipoPago.toUpperCase() == TipoPago.TARJETA.name) {
      t = TipoPago.TARJETA;
    } else if (recoleccion.tipoPago.toUpperCase() ==
        TipoPago.TRANSFERENCIA.name) {
      t = TipoPago.TRANSFERENCIA;
    } else {
      t = TipoPago.YA_PAGADO;
    }
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.green,
    content: const Text('Datos Grabados con Exito'),
    action: SnackBarAction(
      label: '',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  Widget _buildForm(Recoleccion recoleccion) {
    _init(recoleccion);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Ingresar datos de la persona que recibe el producto",
                    style: _miEstilo(),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nombreRecibeController,
                        onChanged: (value) => {
                          recoleccion.nombreRecibe = nombreRecibeController.text
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return "Tien que Ingresar Nombre";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            label: Text("Ingrese Nombre"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: apellidoRecibeController,
                        onChanged: (value) => {
                          recoleccion.apellidoRecibe =
                              apellidoRecibeController.text
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return "Tiene que Ingresar Apellido";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            hintTextDirection: TextDirection.ltr,
                            label: Text("Ingrese Apellido"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onChanged: (value) => {
                          recoleccion.telefonoRecibe =
                              telefonoRecibeController.text
                        },
                        controller: telefonoRecibeController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return "Tiene que Ingresar Telefono";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            label: Text("Ingrese numero de Telefono"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) => {
                          recoleccion.direccionEntrega =
                              direccionController.text
                        },
                        controller: direccionController,
                        maxLength: 200,
                        maxLines: 4,
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return "Tiene que Ingresar direccion Completa";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            label: Text("Ingrese Direccion"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) => {
                          recoleccion.zonaEntrega =
                              int.tryParse(zonaRecibeController.text)!
                        },
                        controller: zonaRecibeController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return "Tiene que Ingresar Zona";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            label: Text("Ingrese Zona"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MunicipioWidget(
                          onChange: (Municipio m) {
                            recoleccion.municipioRecibe.nombre = m.nombre!;
                            recoleccion.municipioRecibe.id = m.id;
                          },
                          initialValue: recoleccion.municipioRecibe.id),
                      const SizedBox(
                        height: 10,
                      ),
                      TipopagoWidget(
                        onChange: (TipoPago tipoPago) {
                          recoleccion.tipoPago = tipoPago.name;

                          if (tipoPago.name == TipoPago.YA_PAGADO.name) {
                            recoleccion.totalCobrar = '0.00';
                            precioProductoController.text = '0.00';
                          }
                        },
                        initValue: t,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) => {
                          recoleccion.totalCobrar =
                              precioProductoController.text
                        },
                        controller: precioProductoController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Ingrese Monto a Cobrar";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            label: Text("Ingrese Monto a Cobrar"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (await Respuesta('Pregunta',
                                  'Seguro Desea Grabar los datos')) {
                                if (recoleccion.id > 0) {
                                  //update
                                  setState(() {
                                    _futureRecoleccion =
                                        grabarRecoleccion(recoleccion);
                                  });
                                } else {
                                  setState(() {
                                    _futureRecoleccion =
                                        grabarRecoleccion(recoleccion);
                                  });
                                }
                                if (mounted) {
                                  Navigator.pop(
                                    context,
                                    ListPage.ROUTE,
                                  );
                                }
                              }
                            }
                          },
                          child: const Text("Grabar"))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<bool> Respuesta(title, String mensaje) async {
    bool? dato = (await showBackDialog(context, title, mensaje)) ?? false;
    return dato;
  }

  FutureBuilder<Recoleccion> buildRecoleccionFutureBuilder() {
    return FutureBuilder<Recoleccion>(
      future: _futureRecoleccion,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            /* if (context.mounted) {
              Navigator.pop(
                context,
                ListPage.ROUTE,
              );
            }*/
          } catch (error) {}
        } else if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        ListPage.ROUTE,
                      );
                    },
                    child: const Text("Presione para Trabajar Offline")),
              ),
            ],
          );
        }

        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }

  Future<Recoleccion> grabarRecoleccion(Recoleccion recoleccion) async {
    bool dato = false;
    if (recoleccion.id > 0) {
      dato = await updateRecoleccion(recoleccion);
      // Operation.instance.updateRecoleccion(recoleccion);
      if (!dato) {
        throw Exception('Failed to update recoleccion.');
      }
    } else {
      dato = await createRecoleccion(recoleccion);
      //Operation.instance.insertRecoleccion(recoleccion);
      if (!dato) {
        throw Exception('Failed to create recoleccion.');
      }
    }
    return recoleccion;
  }

  TextStyle _miEstilo() {
    return const TextStyle(
      fontFamily: 'lato',
      fontSize: 30,
    );
  }
}
