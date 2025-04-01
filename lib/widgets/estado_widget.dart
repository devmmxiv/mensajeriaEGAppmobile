import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/enums/estado_enum.dart';

class EstadoWidget extends StatelessWidget {
  const EstadoWidget({super.key, required this.onChange});
  final void Function(Estado) onChange;
  static var dropdownValue = Estado.creada;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        alignment: AlignmentDirectional.topStart,
        value: dropdownValue,
        hint: const Text(' Seleccione un Estado '),
        decoration: const InputDecoration(labelText: "Estado"),
        items: Estado.values.map((Estado e) {
          return DropdownMenuItem<Estado>(
            value: e,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  e.name.toUpperCase(),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (e.name.toUpperCase() == "CREADA") ...[
                  const Icon(Icons.create),
                ] else if (e.name.toUpperCase() == "RECOLECTADA") ...[
                  const Icon(Icons.credit_card),
                ] else if (e.name.toUpperCase() == "ENRUTA") ...[
                  const Icon(Icons.delivery_dining_outlined),
                ] else if (e.name.toUpperCase() == "ENTREGADA") ...[
                  const Icon(Icons.done),
                ] else ...[
                  const Icon(Icons.block),
                ],
              ],
            ),
          );
        }).toList(),
        onChanged: (val) {
          onChange(val!);
        });
  }
}
