import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:splitly/app/app.dart';
import 'package:splitly/bootstrap.dart';

Future<void> main() async {
  await bootstrap(
    () async {
      await dotenv.load();

      return const App();
    },
  );
}
