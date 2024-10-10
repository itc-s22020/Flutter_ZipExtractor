import 'package:flutter/material.dart';
import 'package:zip_extractor/getX/navigation.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Home"),
                TextButton(onPressed: toResultPage, child: Text("toResult"))
              ],
            )
        )
    );
  }
}