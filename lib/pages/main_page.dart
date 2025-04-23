import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/pages/about.dart';
import 'package:mobile_app_mensajeria/pages/lista_http_page.dart';
import 'package:mobile_app_mensajeria/pages/login.dart';
import 'package:mobile_app_mensajeria/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const String ROUTE = '/main';
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  bool up = false;

  String usuario = "";
  late UserLogeado singleton;
  @override
  void initState() {
    super.initState();
    singleton = UserLogeado();
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        Navigator.pushReplacementNamed(context, LoginPage.ROUTE);
      case 1:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    up = !up;
    usuario = singleton.getUser();
//se pone test para probar recolecciones desde clientes
    final screens = [const ListPageTest(), const About()];
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            "Mensajeria EG",
            style: TextStyle(fontFamily: 'Lato', fontSize: 18.00),
          ),
          backgroundColor: colors.primary,
          //leading: const Icon(Icons.import_contacts),
          actions: [
            Row(children: [
              const Icon(
                Icons.person,
                color: Colors.white,
              ),
              Text(usuario,
                  style: const TextStyle(fontFamily: 'Lato', fontSize: 16.00))
            ]),
            PopupMenuButton<int>(
                onSelected: (item) => handleClick(item),
                itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                              Text('Salir',
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal))
                            ],
                          )),
                      PopupMenuItem<int>(
                          value: 1,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Profile()));
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.settings,
                                color: Colors.black,
                              ),
                              Text('Cambiar Contraseña',
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal))
                            ],
                          )),
                    ]),
          ]),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              activeIcon: const Icon(Icons.list_alt_outlined),
              label: 'Detalle',
              backgroundColor: colors.primary),
          BottomNavigationBarItem(
              icon: const Icon(Icons.info_outline),
              activeIcon: const Icon(Icons.info),
              label: 'Info',
              backgroundColor: colors.primary),
        ],
      ),
    );
  }
}
