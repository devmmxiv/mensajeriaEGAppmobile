import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/enums/tipo_pago_enum.dart';

class TipopagoWidget extends StatelessWidget {
  const TipopagoWidget({super.key, required this.onChange, required this.initValue});

  final void Function(TipoPago) onChange;

  final TipoPago initValue;
  @override
  Widget build(BuildContext context) {
  
    return DropdownButtonFormField(
        alignment: AlignmentDirectional.topStart,
        value: initValue,
        hint: const Text(' Seleccione un Tipo de Pago'),
        decoration: const InputDecoration(labelText: "Tipo de Pago"),
        items: TipoPago.values.map((TipoPago e) {
          return DropdownMenuItem<TipoPago>(
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
                if (e.name.toUpperCase() == "EFECTIVO") ...[
                  const Icon(Icons.paid),
                ] else if (e.name.toUpperCase() == "TARJETA") ...[
                  const Icon(Icons.credit_card),
                ] else if (e.name.toUpperCase() == "TRANSFERENCIA") ...[
                  const Icon(Icons.account_balance),
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
