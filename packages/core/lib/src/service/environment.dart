import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  const Environment._();

  static final _geminiAPiKey = dotenv.env['GEMINI_API_KEY'];

  static String get geminiApiKey {
    try {
      if (_geminiAPiKey == null) throw Exception('Variable null or not found');

      return _geminiAPiKey ?? '';
    } catch (e) {
      log('Error loading GeminiApiKey from .env: $e');
      return '';
    }
  }
}
