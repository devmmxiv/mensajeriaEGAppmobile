import 'package:mobile_app_mensajeria/models/municpios_model.dart';

class Recoleccion {
  int id;
  String fechaCreacion; //": "2024-09-26T16:17:08.328Z",
  String nombreRecibe; //": "Antonio",
  String apellidoRecibe; //": "Martinez",
  String telefonoRecibe; // ": "5656533323",

  String precioEnvio;
  String totalCobrar;
  String direccionEntrega; //":
  int zonaEntrega;
  String estado; //": "CREADA",
  String tipoPago; //": "EFECTIVO",
  Municipio municipioRecibe;
  Cliente clienteEnvia;
  Empleado? empleadoAsignado;

  Recoleccion(
      this.id,
      this.fechaCreacion,
      this.nombreRecibe,
      this.apellidoRecibe,
      this.telefonoRecibe,
      this.totalCobrar,
      this.precioEnvio,
      this.direccionEntrega,
      this.zonaEntrega,
      this.estado,
      this.tipoPago,
      this.municipioRecibe,
      this.clienteEnvia,
      this.empleadoAsignado);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fechaCreacion': fechaCreacion,
      'nombreRecibe': nombreRecibe,
      'apellidoRecibe': apellidoRecibe,
      'telefonoRecibe': telefonoRecibe,
      'totalCobrar': totalCobrar,
      'direccionEntrega': direccionEntrega,
      'precioEnvio': precioEnvio,
      'zonaEntrega': zonaEntrega,
      'estado': estado,
      'tipoPago': tipoPago,
      'clienteEnvia': clienteEnvia.toMap(),
      'empleadoAsignado': empleadoAsignado?.toMap(),
      'municipioRecibe': municipioRecibe.toMap()
    };
  }

  Recoleccion.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        fechaCreacion = json['fechaCreacion'] as String,
        nombreRecibe = json['nombreRecibe'] as String,
        apellidoRecibe = json['apellidoRecibe'] as String,
        telefonoRecibe = json['telefonoRecibe'] as String,
        totalCobrar = json['totalCobrar'] as String,
        precioEnvio = json['precioEnvio'] as String,
        direccionEntrega = json['direccionEntrega'] as String,
        zonaEntrega = json['zonaEntrega'] as int,
        estado = json['estado'] as String,
        tipoPago = json['tipoPago'] as String,
        // idMunicipioRecibe = json['idMunicipioRecibe'] as int,
        municipioRecibe = Municipio.fromJson(json['municipioRecibe']),
        clienteEnvia = Cliente.fromJson(json['clienteEnvia']),
        empleadoAsignado = Empleado.fromJson(json['empleadoAsignado']);
}

class RecoleccionInsert {
  int id;
  String fechaCreacion; //": "2024-09-26T16:17:08.328Z",
  String nombreRecibe; //": "Antonio",
  String apellidoRecibe; //": "Martinez",
  String telefonoRecibe; // ": "5656533323",

  String precioEnvio;
  String totalCobrar;
  String direccionEntrega; //":
  int zonaEntrega;
  String estado; //": "CREADA",
  String tipoPago; //": "EFECTIVO",
  Municipio municipioRecibe;
  ClienteInsert clienteEnvia;

  RecoleccionInsert(
    this.id,
    this.fechaCreacion,
    this.nombreRecibe,
    this.apellidoRecibe,
    this.telefonoRecibe,
    this.totalCobrar,
    this.precioEnvio,
    this.direccionEntrega,
    this.zonaEntrega,
    this.estado,
    this.tipoPago,
    this.municipioRecibe,
    this.clienteEnvia,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fechaCreacion': fechaCreacion,
      'nombreRecibe': nombreRecibe,
      'apellidoRecibe': apellidoRecibe,
      'telefonoRecibe': telefonoRecibe,
      'totalCobrar': totalCobrar,
      'direccionEntrega': direccionEntrega,
      'precioEnvio': precioEnvio,
      'zonaEntrega': zonaEntrega,
      'estado': estado,
      'tipoPago': tipoPago,
      'clienteEnvia': clienteEnvia.toMap(),
      'municipioRecibe': municipioRecibe.toMap()
    };
  }

  RecoleccionInsert.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        fechaCreacion = json['fechaCreacion'] as String,
        nombreRecibe = json['nombreRecibe'] as String,
        apellidoRecibe = json['apellidoRecibe'] as String,
        telefonoRecibe = json['telefonoRecibe'] as String,
        totalCobrar = json['totalCobrar'] as String,
        precioEnvio = json['precioEnvio'] as String,
        direccionEntrega = json['direccionEntrega'] as String,
        zonaEntrega = json['zonaEntrega'] as int,
        estado = json['estado'] as String,
        tipoPago = json['tipoPago'] as String,
        // idMunicipioRecibe = json['idMunicipioRecibe'] as int,
        municipioRecibe = Municipio.fromJson(json['municipioRecibe']),
        clienteEnvia = ClienteInsert.fromJson(json['clienteEnvia']);
}

class ClienteInsert {
  int? id;

  ClienteInsert({
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory ClienteInsert.fromJson(Map<String, dynamic> json) {
    return ClienteInsert(
      id: json['id'],
    );
  }
}

class Cliente {
  int? id;
  String? nombre;
  String? apellido;
  String? telefono;
  List<Direccion> direcciones;
  Cliente(
      {this.id,
      this.nombre,
      this.apellido,
      this.telefono,
      required this.direcciones});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'direcciones': direcciones.map((item) => item.toMap()).toList()
    };
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
        id: json['id'],
        nombre: json['nombre'],
        apellido: json['apellido'],
        telefono: json['telefono'],
        direcciones: List<dynamic>.from(json['direcciones'])
            .map((i) => Direccion.fromJson(i))
            .toList());
  }
}

class Empleado {
  int? id;
  String? nombre;
  String? apellido;
  String? telefono;
  Empleado({this.id, this.nombre, this.apellido, this.telefono});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre};
  }

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
        id: json['id'] ?? 0,
        nombre: json['nombre'] ?? '',
        apellido: json['apellido'] ?? '',
        telefono: json['telefono'] ?? '');
  }
}

class Direccion {
  int? id;
  String? direccionCompleta;
  int? zona;
  Municipio municipio;
  Direccion(
      {this.id, this.direccionCompleta, this.zona, required this.municipio});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'direccionCompleta': direccionCompleta,
      'zona': zona,
      'municipio': municipio.toMap()
    };
  }

  factory Direccion.fromJson(Map<String, dynamic> json) {
    return Direccion(
        id: json['id'] ?? 0,
        direccionCompleta: json['direccionCompleta'],
        zona: json['zona'] ?? 0,
        municipio: Municipio.fromJson(json['municipio']));
  }
}
