import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Mensajeria EyG.\n Todos los derechos reservados.',
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.normal)),
            Row(
              children: [
                Text('2025',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.normal)),
                Icon(IconData(0xe198, fontFamily: 'MaterialIcons')),
                Text('Version 1.0.3',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.normal))
              ],
            )
          ],
        ));

    ;
  }
}
