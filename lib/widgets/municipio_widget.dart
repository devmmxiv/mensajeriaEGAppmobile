import 'package:flutter/material.dart';
import 'package:mobile_app_mensajeria/models/municpios_model.dart';

class MunicipioWidget extends StatelessWidget {
  const MunicipioWidget(
      {super.key, required this.onChange, required this.initialValue});
  final void Function(Municipio) onChange;
  final int initialValue;

  @override
  Widget build(BuildContext context) {
    Municipio d =
        Municipio.getMunicipios.firstWhere((e) => e.id == initialValue);

    return DropdownButtonFormField(
      alignment: AlignmentDirectional.topStart,
      value: d,
      hint: const Text(' Seleccione un Municipio '),
      decoration: const InputDecoration(labelText: "Municipio"),
      items: Municipio.getMunicipios.map((m) {
        return DropdownMenuItem<Municipio>(
          value: m,
          child: Text(m.nombre!),
        );
      }).toList(),
      onChanged: (v) {
        onChange(v!);
      },
    );
  }
}
