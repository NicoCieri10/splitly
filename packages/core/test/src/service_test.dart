import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('Service', () {
    test('can be accesed', () {
      expect(Environment.geminiApiKey, isNotEmpty);
    });
  });
}
