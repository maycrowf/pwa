import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static const localUrl = 'http://192.168.2.41:8080';
  static final baseUrl = dotenv.get('BASE_URL', fallback: localUrl);
}
