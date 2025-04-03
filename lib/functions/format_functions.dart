import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

String formaterNumber(String valor) {
  return CurrencyFormatter.format(valor, gtSettings,
      decimal: 2, enforceDecimals: true);
}

const CurrencyFormat gtSettings = CurrencyFormat(
  // formatter settings for euro
  code: 'gtq',
  symbol: 'Q',
  symbolSide: SymbolSide.left,
  thousandSeparator: ',',
  decimalSeparator: '.',
  symbolSeparator: ' ',
);

String formatoFecha(String fecha) {
  return DateFormat("dd-MM-yyyy").format(DateTime.parse(fecha));
}

Uri getUri(String path) {
  String versionapi = dotenv.env['VERSIONAPI'].toString();
  String server = dotenv.env['SERVER'].toString();
  String scheme = dotenv.env['SCHEME'].toString();
  String puerto = dotenv.env['PORT'].toString();
  int port = int.parse(puerto);
  Uri uri = Uri();
  try {
    if (port==0){
  uri = Uri(
        scheme: scheme,
        host: server,
        path: path //'/api/v1/auth/data-user',
        );
    }else{
  uri = Uri(
        scheme: scheme,
        host: server,
        port: port,
        path: path //'/api/v1/auth/data-user',
        );
    }
  
  } catch (e) {
    //print('Error en crear uri ' + e.toString());
  }

  return uri;
}
