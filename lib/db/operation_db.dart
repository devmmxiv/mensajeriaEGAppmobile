import 'dart:async';

//import 'package:sqflite/sqflite.dart';
import 'package:mobile_app_mensajeria/models/municpios_model.dart';
import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class Operation {
  static final Operation instance = Operation._init();

  static Database? _database;

  Operation._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('recoleccionesdb.db');
    //_database = await initWinDB();
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''CREATE TABLE recoleccion 
          (id INTEGER ,
           fechaCreacion TEXT,
           nombreRecibe TEXT,
           apellidoRecibe TEXT,
           telefonoRecibe TEXT,
           precioProducto TEXT,
           direccionEntrega TEXT,
           estado TEXT 
          ,tipoPago TEXT , 
          idMunicipioRecibe INTEGER,
          municipioRecibe TEXT,
          idClienteEnvia INTEGER,
          idDireccionClienteEnvia INTEGER) ''');
  }

  Future<bool> insertRecoleccion(Recoleccion item) async {
    bool dato = true;
    try {
      final db = await instance.database;
      db.insert("recoleccion", item.toMap());
    } catch (e) {
      dato = false;
    }
    return dato;
  }

  Future<int> deleteRecoleccion(Recoleccion item) async {
    final db = await instance.database;

    return await db
        .delete("recoleccion", where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> updateRecoleccion(Recoleccion item) async {
    final db = await instance.database;

    return await db.update("recoleccion", item.toMap(),
        where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> updateEstado(String estado, int id) async {
    final db = await instance.database;
    return await db.rawUpdate('''
    UPDATE recoleccion 
    SET estado = ? 
    WHERE id = ?
    ''', [estado, id]);
  }

  Future<List<Recoleccion>> getRecolecciones() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> recoleccionesMap =
        await db.query("recoleccion");

    return List.generate(
        recoleccionesMap.length,
        (i) => Recoleccion(
            recoleccionesMap[i]['id'],
            recoleccionesMap[i]['fechaCreacion'],
            recoleccionesMap[i]['nombreRecibe'],
            recoleccionesMap[i]['apellidoRecibe'],
            recoleccionesMap[i]['telefonoRecibe'],
            recoleccionesMap[i]['precioProducto'],
            recoleccionesMap[i]['montoEnvio'],
            recoleccionesMap[i]['direccionEntrega'],
            recoleccionesMap[i]['zona'],
            recoleccionesMap[i]['estado'],
            recoleccionesMap[i]['tipoPago'],
            // recoleccionesMap[i]['idDireccionClienteEnvia'],
            Municipio.fromJson(recoleccionesMap[i]['municipioRecibe']),
            Cliente.fromJson(recoleccionesMap[i]['clienteEnvia']),
            Empleado.fromJson(recoleccionesMap[i]['empleadoAsignado'])));
  }

  Future<List<Recoleccion>> getRecoleccionesEntregadas() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> recoleccionesMap = await db
        .rawQuery('SELECT * FROM recoleccion WHERE estado = ?', ['entregada']);

    return List.generate(
        recoleccionesMap.length,
        (i) => Recoleccion(
            recoleccionesMap[i]['id'],
            recoleccionesMap[i]['fechaCreacion'],
            recoleccionesMap[i]['nombreRecibe'],
            recoleccionesMap[i]['apellidoRecibe'],
            recoleccionesMap[i]['telefonoRecibe'],
            recoleccionesMap[i]['precioProducto'],
            recoleccionesMap[i]['montoEnvio'],
            recoleccionesMap[i]['direccionEntrega'],
            recoleccionesMap[i]['zona'],
            recoleccionesMap[i]['estado'],
            recoleccionesMap[i]['tipoPago'],
            // recoleccionesMap[i]['idDireccionClienteEnvia'],
            Municipio.fromJson(recoleccionesMap[i]['municipioRecibe']),
            Cliente.fromJson(recoleccionesMap[i]['clienteEnvia']),
            Empleado.fromJson(recoleccionesMap[i]['empleadoAsignado'])));
  }
  /*
   static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'recoleccionesdb.db'),
        onCreate: (db, version) {
      db.execute(
          "CREATE TABLE recoleccion (id INTEGER PRIMARY KEY, fechaCreacion TEXT,      nombreRecibe TEXT,      apellidoRecibe TEXT,      telefonoRecibe TEXT,      totalCobrar TEXT,      direccionEntrega TEXT,      estado TEXT ,      tipoPago TEXT ,      municipioRecibe TEXT) ");
    }, version: 1);
  }

 static Future<int> insert(Recoleccion recoleccion) async {
    Database database = await _openDB();
    return database.insert("recoleccion", recoleccion.toMap());
  }

  static Future<List<Recoleccion>> recolecciones() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> recoleccionesMap =
        await database.query("recoleccion");

    return List.generate(
        recoleccionesMap.length,
        (i) => Recoleccion(
            recoleccionesMap[i]['id'],
            recoleccionesMap[i]['fechaCreacion'],
            recoleccionesMap[i]['nombreRecibe'],
            recoleccionesMap[i]['apellidoRecibe'],
            recoleccionesMap[i]['telefonoRecibe'],
            recoleccionesMap[i]['totalCobrar'],
            recoleccionesMap[i]['direccionEntrega'],
            recoleccionesMap[i]['estado'],
            recoleccionesMap[i]['tipoPago'],
            recoleccionesMap[i]['municipioRecibe']));
  }*/
}
