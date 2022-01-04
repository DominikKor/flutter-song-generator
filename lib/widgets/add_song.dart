import 'package:flutter/material.dart';
import 'package:liedgenerator/models/song.dart';
import 'package:liedgenerator/util/sqflite_helper.dart';

class AddSong extends StatelessWidget {
  AddSong({Key? key}) : super(key: key);

  final TextEditingController numberInputController = TextEditingController();
  final FocusNode numberInputFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 32, left: 28, right: 50),
        child: Column(
          children: [
            TextField(
              controller: numberInputController,
              focusNode: numberInputFocusNode,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Add new song", icon: Icon(Icons.music_note)),
              onSubmitted: (String newSong) {
                SqlHelper().insertSong(Song(
                  int.parse(newSong),
                  false,
                  false,
                ));
                numberInputController.clear();
                numberInputFocusNode.requestFocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
