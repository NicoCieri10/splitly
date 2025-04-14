import 'package:core/core.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AppRepository {
  static GenerativeModel get _model => GenerativeModel(
        model: 'gemini-2.0-flash-latest',
        apiKey: Environment.geminiApiKey,
      );

  static Future<void> getGenerativeResponse(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
  }
}
