import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
     static const String ROUTE = "/profile";
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    return (Scaffold(
        appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
            backgroundColor: colors.primary,
            title: const Text("Datos para Recoleccion",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))),
        body: Container()));
  }
}
