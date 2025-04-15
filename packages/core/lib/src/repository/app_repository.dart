import 'dart:developer';

import 'package:core/core.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AppRepository {
  static GenerativeModel get _model => GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: Environment.geminiApiKey,
      );

  static Future<GenerativeResponse?> getGenerativeResponse(
    PromptData prompt,
  ) async {
    try {
      final content = [
        Content.text(
          prompt.toPrompt(),
        ),
      ];
      final response = await _model.generateContent(content);
      final data = response.text;

      if (data == null || data.isEmpty) throw Exception();

      log(data);

      return GenerativeResponse.fromJson(data);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
