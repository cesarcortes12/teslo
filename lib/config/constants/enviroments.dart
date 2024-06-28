
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment{
//SE UTILOZO DEPEDENCIA flutter_dotenv
  static initEnviroment() async {
    await dotenv.load(fileName: ".env");
  }

  static String apiUrl = dotenv.env['API_URL'] ?? 'no esta configurada el API_URL';
}