part of '../app.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = router(context);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            fontFamily: 'Quicksand',
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
          builder: (context, child) => child!,
        );
      },
    );
  }

  GoRouter router(BuildContext context) {
    return GoRouter(
      initialLocation: InitialPage.route,
      routes: <GoRoute>[
        GoRoute(
          name: InitialPage.route,
          path: InitialPage.route,
          builder: (_, state) => InitialPage(key: state.pageKey),
        ),
        GoRoute(
          name: HomePage.route,
          path: HomePage.route,
          builder: (_, state) => HomePage(key: state.pageKey),
        ),
      ],
    );
  }
}
