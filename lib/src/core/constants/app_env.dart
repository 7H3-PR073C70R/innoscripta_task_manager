import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static String get apiBaseURL => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiToken => dotenv.env['API_TOKEN'] ?? '';
}
