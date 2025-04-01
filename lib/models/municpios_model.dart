class Municipio {
  int? id;
  String? name;
  String? code;
  Municipio({this.id, this.name, this.code});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'code': code};
  }

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(
        id: json['id'] ?? 0,
        name: json['nombre'] ?? '',
        code: json['apellido'] ?? '');
  }
  static List<Municipio> getMunicipios = <Municipio>[
    Municipio(id: 1, name: 'Guatemala', code: '1'),
    Municipio(id: 2, name: 'Amatitlan', code: '2'),
    Municipio(id: 3, name: 'San Jose Pinula', code: '3'),
    Municipio(id: 4, name: 'Santa Catarina Pinula', code: '4'),
    Municipio(id: 5, name: 'San Miguel Petapa', code: '5'),
    Municipio(id: 6, name: 'Villa Canales', code: '6'),
    Municipio(id: 7, name: 'Villa Nueva', code: '7'),
    Municipio(id: 8, name: 'Mixco', code: '8'),
  ];
}
