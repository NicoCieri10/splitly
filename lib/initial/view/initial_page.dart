import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:splitly/home/home.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  static const route = '/';

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_initCallback);
  }

  Future<void> _initCallback(_) async {
    await Future.delayed(const Duration(seconds: 3), () {});

    if (!mounted) return;

    context.replaceNamed(HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Splitly',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
