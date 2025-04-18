import 'package:core/core.dart';
import 'package:flutter/material.dart';

class HomeSuccessBody extends StatelessWidget {
  const HomeSuccessBody(this.response, {super.key});

  final GenerativeResponse? response;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            response?.summary?.totalSpent.toString() ?? 'N/D',
          ),
          Text(
            response?.summary?.persons.toString() ?? 'N/D',
          ),
          Text(
            response?.byPerson.toString() ?? 'N/D',
          ),
        ],
      ),
    );
  }
}
