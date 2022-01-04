import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Song Generator"),
      ),
      body: Center(child:
        Column(
          children: [
            Text("Made by Dominik Korolko in 2022"),
            Text("App Icon by https://icons8.com"),
          ],
        )
      ),
    );
  }
}
