import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile_app_mensajeria/api/api_cliente.dart';
import 'package:mobile_app_mensajeria/api/api_empleado.dart';
import 'package:mobile_app_mensajeria/functions/http_functions.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/pages/main_page.dart';
import 'package:mobile_app_mensajeria/widgets/form_custom_widget.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  // ignore: constant_identifier_names
  static const String ROUTE = '/';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  // SharedPreferences? _prefs;
  String mensaje = "";
  @override
  void initState() {
    cargarPreferencias();
    super.initState();
  }

  cargarPreferencias() async {
    // _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/images/logoEyG.jpg'),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormCustomWidget(
                    name: 'user',
                    obscureText: false,
                    hintText: 'Usuario',
                    icon: Icons.person,
                    keyboardType: TextInputType.text,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          checkNullOrEmpty: true,
                          errorText: 'Usuario Requerido'),
                      FormBuilderValidators.minLength(4,
                          errorText: 'Minimo 4 Caracteres')
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormCustomWidget(
                    name: 'password',
                    obscureText: true,
                    hintText: 'Contraseña',
                    icon: Icons.lock,
                    keyboardType: TextInputType.text,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          checkNullOrEmpty: true,
                          errorText: 'Contraseña Requerido'),
                      FormBuilderValidators.minLength(4,
                          errorText: 'Minimo 4 Caracteres')
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                    onPressed: () async {
                      _formKey.currentState?.save();

                      if (_formKey.currentState?.validate() == true) {
                        final v = _formKey.currentState?.value;

                        String user = v?['user'];
                        String pwd = v?['password'];
                        bool dato = await validarUsuario(user, pwd);

                        if (dato) {
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                                context, MainPage.ROUTE);
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(mensaje)));
                          }
                        }
                      }
                    },
                    child: const Text('Iniciar Sesion'))
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<bool> validarUsuario(String user, String pwd) async {
    setState(() {
        mensaje = "usuario/contraseña invalidos";
      });
    var token = await login(user, pwd);
    if (token.isEmpty) {
      
      return false;
    } else {
      try {
        final tokenF = jsonDecode(token) as Map<String, dynamic>;
        var usuarioJson = await dataUser(tokenF['accessToken']);

        final userMap = jsonDecode(usuarioJson) as Map<String, dynamic>;
        final loginValidado = Login.fromJson(userMap);

        if (loginValidado.estado) {
          UserLogeado singleton = UserLogeado();
          singleton.setUser(loginValidado.username);
          singleton.setPerfilUsuario(loginValidado.perfilUsuario);
          //buscamos el id del usuario o empleado segun el perfil
          if (loginValidado.perfilUsuario == 'CLIENTE') {
            //BUSCAMOS CLIENTE
            var c = await getClienteByUser(loginValidado.username);

            final cliente = jsonDecode(c) as Map<String, dynamic>;
            int id = cliente['id'];
            singleton.setId(id);
          } else {
            var e = await getEmpleadoByUser(loginValidado.username);

            final empleado = jsonDecode(e) as Map<String, dynamic>;

            int id = empleado['id'];
            bool esAdmin = empleado['esAdministrador'];
            singleton.setId(id);
            singleton.setIsAdmin(esAdmin);
            //buscamos emplead
          }

          // Set data through the singleton instance.
        } 
        return loginValidado.estado;
      } catch (error) {
        setState(() {
        mensaje = error.toString();
      });
        

        return false;
      }
    }
  }
}
