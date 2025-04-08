import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/models/login_model.dart';
import 'package:mobile_app_mensajeria/pages/about.dart';
import 'package:mobile_app_mensajeria/pages/list_page.dart';
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
    singleton = UserLogeado();

    super.initState();
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

    final screens = [const ListPage(), const Profile()];
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            "Mensajeria EyG",
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
              Text(usuario)
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
                              Text('Salir')
                            ],
                          )),
                      /*const PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings,
                                color: Colors.black,
                              ),
                              Text('Perfil')
                            ],
                          )),*/
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
              icon: const Icon(Icons.two_wheeler),
              activeIcon: const Icon(Icons.list_alt_outlined),
              label: 'Detalle',
              backgroundColor: colors.primary),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              activeIcon: const Icon(Icons.person_2_outlined),
              label: 'Perfil',
              backgroundColor: colors.primary),
         
        ],
      ),
    );
  }
}
