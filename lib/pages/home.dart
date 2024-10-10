import 'package:flutter/material.dart';
import 'package:zip_extractor/components/file_pick.dart';
import 'package:zip_extractor/getX/navigation.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body : Column(
          children: [
            Text("Home"),
            TextButton(onPressed: filePick, child: Text("filePick")),
            TextButton(onPressed: toResultPage, child: Text("toResult"))
          ],
        )
    );
  }
}