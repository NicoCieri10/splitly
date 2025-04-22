import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/home/home.dart';
import 'package:splitly/home/widget/widget.dart';

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

    // context.replaceNamed(HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 225, 255),
      body: Column(
        children: [
          const Spacer(flex: 2),
          Text(
            'Splitly',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              fontSize: 40.sp,
              color: primaryColor.withAlpha(155),
            ),
          ),
          const Spacer(flex: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: const LinearProgressIndicator(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
