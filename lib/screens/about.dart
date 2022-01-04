import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  final List<String> information = const [
    "Made by Dominik Korolko in 2022",
    "App Icon by https://icons8.com",
  ];

  final TextStyle textStyle = const TextStyle(
    color: Colors.grey,
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Song Generator"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
              children: () {
                    List<Widget> texts = [];
                    for (String text in information) {
                      texts.add(
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            text,
                            style: textStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return texts;
                  }() +
                  [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Song Generator is OpenSource! Check it out on ',
                            style: textStyle,
                          ),
                          TextSpan(
                            text: 'GitHub',
                            style: const TextStyle(color: Colors.blue, fontSize: 14),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launch(
                                    'https://github.com/DrokoDomi/song_generator');
                              },
                          ),
                        ],
                      ),
                    ),
                  ]),
        ),
      ),
    );
  }
}
