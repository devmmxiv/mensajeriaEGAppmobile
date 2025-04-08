class TipoPago {
  final String name;
  final String code;
  final String icon;
  const TipoPago(this.name, this.code, this.icon);
}

const List<TipoPago> getTipoPago = <TipoPago>[
  TipoPago('EFECTIVO', 'EFECTIVO', '1'),
  TipoPago('TRANSFERENCIA', 'TRANSFERENCIA', '2'),
  TipoPago('TARJETA', 'TARJETA', '3'),
  TipoPago('YAPAGADO', 'YAPAGADO', '4'),
];
