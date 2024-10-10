import 'package:flutter/material.dart';

import '../getX/navigation.dart';

class Result extends StatelessWidget {

  const Result({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Home"),
            TextButton(onPressed: toHomePage, child: Text("toHome"))
          ],
        )
    );
  }
}