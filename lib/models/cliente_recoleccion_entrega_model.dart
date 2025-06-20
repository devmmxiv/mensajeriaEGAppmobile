import 'package:mobile_app_mensajeria/models/municpios_model.dart';
import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';

class ClienteRecoleccionEntrega {
  int? id;
  String? nombre;
  String? apellido;
  String? telefono;
  List<Direccion>? direcciones;
  List<RecoleccionEntrega>? recolecciones;
  ClienteRecoleccionEntrega(
      {this.id,
      this.nombre,
      this.apellido,
      this.telefono,
      this.recolecciones,
      this.direcciones});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'direcciones': direcciones!.map((item) => item.toMap()).toList(),
      'recolecciones': recolecciones?.map((item) => item.toMap()).toList()
    };
  }

  factory ClienteRecoleccionEntrega.fromJson(Map<String, dynamic> json) {
    return ClienteRecoleccionEntrega(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      recolecciones: List<dynamic>.from(json['envios'])
          .map((i) => RecoleccionEntrega.fromJson(i))
          .toList(),
      direcciones: List<dynamic>.from(json['direcciones'])
          .map((i) => Direccion.fromJson(i))
          .toList(),
    );
  }
}

class RecoleccionEntrega {
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
  //Cliente clienteEnvia;
  Empleado? empleadoAsignado;
  ClienteInsert? clienteEnvia;
  RecoleccionEntrega(
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
      // this.clienteEnvia,
      this.empleadoAsignado,
      this.clienteEnvia);

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
      // 'clienteEnvia': clienteEnvia.toMap(),
      'empleadoAsignado':
          empleadoAsignado == null ? Empleado : empleadoAsignado?.toMap(),
      'municipioRecibe': municipioRecibe.toMap(),
      'clienteEnvia':
          clienteEnvia == null ? ClienteInsert : clienteEnvia?.toMap()
    };
  }

  RecoleccionEntrega.fromJson(Map<String, dynamic> json)
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
        // clienteEnvia = Cliente.fromJson(json['clienteEnvia']),
        empleadoAsignado = json['empleadoAsignado'] == null
            ? Empleado()
            : Empleado.fromJson(json['empleadoAsignado']),
        clienteEnvia = json['clienteEnvia'] == null
            ? ClienteInsert()
            : ClienteInsert.fromJson(json['clienteEnvia']);
}
