import 'package:flutter/material.dart';

Future<bool?> showBackDialog(
    BuildContext context, String title, String mensaje) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          mensaje,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Si'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> showConfirmDialog(
    BuildContext context, String title, String mensaje) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          mensaje,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}

Future<bool> respuesta(
    BuildContext contexto, title, String mensaje, bool confirm) async {
  bool? dato = false;
  if (confirm) {
    dato = (await showConfirmDialog(contexto, title, mensaje)) ?? true;
  } else {
    dato = (await showBackDialog(contexto, title, mensaje)) ?? false;
  }

  return dato;
}
