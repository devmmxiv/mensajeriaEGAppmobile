import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:mobile_app_mensajeria/pages/login.dart';
import 'package:mobile_app_mensajeria/pages/main_page.dart';
import 'package:mobile_app_mensajeria/pages/save_page.dart';
import 'package:sizer/sizer.dart';

void main() async {
  // Initialize FFI
//  sqfliteFfiInit();

  //databaseFactory = databaseFactoryFfi;
  await dotenv.load(fileName: ".env");
  runApp(const MensajeriaApp());
}

class MensajeriaApp extends StatelessWidget {
  const MensajeriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: LoginPage.ROUTE,
        
          routes: {
            MainPage.ROUTE: (_) => const MainPage(),
            LoginPage.ROUTE: (_) => const LoginPage(),
            // ignore: equal_keys_in_map
            //  ListPage.ROUTE: (_) => const ListPage(),
            SavePage.ROUTE: (_) => const SavePage()
          },
        );
      },
    );
  }
}
