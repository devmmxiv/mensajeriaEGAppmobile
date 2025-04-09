import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/functions/http_functions.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/pages/list_page.dart';
import 'package:mobile_app_mensajeria/pages/login.dart';
import 'package:mobile_app_mensajeria/pages/show_message_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  static const String ROUTE = "/profile";
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserLogeado user;
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    user = UserLogeado();
  }

  @override
  Widget build(BuildContext context) {
    String password = "";
    String rePassword = "";
    final colors = Theme.of(context).colorScheme;
    return (Scaffold(
      appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: colors.primary,
          title: const Text("Cambiar Contraseña",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.normal))),
      body: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /*   const Text("CAMBIO DE CONTRASEÑA", style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.normal)),
              const SizedBox(
                height: 10,
              ),*/
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        onChanged: (value) =>
                            {password = passwordController.text},
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return "Tien que Ingresar Contraseña";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            label: Text("Ingrese Nueva Contraseña"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: rePasswordController,
                        onChanged: (value) =>
                            {rePassword = rePasswordController.text},
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return "Repita la Contraseña";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            label: Text("Repita la Contraseña"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String mensaje = "Contraseñas incorrectas";
                              if (password.length < 6) {
                                mensaje =
                                    "La contraseña no puede ser menor a 6 caracteres";
                                if (mounted) {
                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(
                                          SnackBar(content: Text(mensaje)));
                                }
                              } else if (password != rePassword) {
                                if (mounted) {
                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(
                                          SnackBar(content: Text(mensaje)));
                                }
                              } else {
                                if (await Respuesta('Pregunta',
                                    'Seguro Desea Cambiar la Contraseña')) {
                                  setState(() {
                                    mensaje =
                                        "No se pudo cambiar la contraseña";
                                  });

                                  bool dato = await updateContrasena(
                                      user.user, password);
                                  if (dato) {
                                    if (mounted) {
                                      Navigator.pop(
                                        this.context,
                                        ListPage.ROUTE,
                                      );
                                    }
                                    setState(() {
                                      mensaje = "Contraseña cambiada con exito";
                                      if (mounted) {
                                        ScaffoldMessenger.of(this.context)
                                            .showSnackBar(SnackBar(
                                                content: Text(mensaje)));
                                      }
                                    });
                                  } else {
                                    if (mounted) {
                                      ScaffoldMessenger.of(this.context)
                                          .showSnackBar(
                                              SnackBar(content: Text(mensaje)));
                                    }
                                  }
                                }
                              }
                            }
                          },
                          child: const Text("Actualizar Contraseña"))
                    ],
                  ))
            ],
          )),
    ));
  }

  Future<bool> Respuesta(title, String mensaje) async {
    bool? dato = (await showBackDialog(context, title, mensaje)) ?? false;
    return dato;
  }
}
