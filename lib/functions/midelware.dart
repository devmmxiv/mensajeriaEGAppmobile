import 'package:mobile_app_mensajeria/functions/http_functions.dart';
import 'package:mobile_app_mensajeria/models/recoleccion_model.dart';

class Midelware {
  Midelware._privateConstructor();

  static final Midelware _instance = Midelware._privateConstructor();

  static Midelware get instance => _instance;

  bool isInternet = true;

  Future<List<Recoleccion>> gtDataReady() async {
    try {
      List<Recoleccion> listaReady = await getRecoleccionesHttp();
      return listaReady;
    } catch (e) {
      isInternet = false;
      rethrow;
    }
  }
}
