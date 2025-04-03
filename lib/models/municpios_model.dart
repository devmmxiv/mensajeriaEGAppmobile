class Municipio {
  int id;
  String? nombre;

  Municipio({required this.id, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre};
  }

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(id: json['id'] ?? 0, nombre: json['nombre'] ?? '');
  }
  static List<Municipio> getMunicipios = <Municipio>[
    Municipio(id: 1, nombre: 'Guatemala'), //, code: '1'),
    Municipio(id: 2, nombre: 'Amatitlan'), //, code: '1'),
    Municipio(id: 3, nombre: 'San Jose Pinula'), //, code: '1'),
    Municipio(id: 4, nombre: 'Santa Catarina Pinula'), //, code: '1'),
    Municipio(id: 5, nombre: 'San Miguel Petapa'), //, code: '1'),
    Municipio(id: 6, nombre: 'Villa Canales'), //, code: '1'),
    Municipio(id: 7, nombre: 'Villa Nueva'), //, code: '1'),
    Municipio(id: 8, nombre: 'Mixco'), // code: '8'),
    Municipio(id: 9, nombre: 'Fraijanes'), //, code: '1'),
  ];
}
