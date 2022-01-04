import 'package:flutter/material.dart';
import 'package:liedgenerator/models/song.dart';
import 'package:liedgenerator/util/sqflite_helper.dart';
import 'dart:math';

class SongGrid extends StatefulWidget {
  const SongGrid({Key? key, required this.dontRepeat}) : super(key: key);

  final bool dontRepeat;

  @override
  _SongGridState createState() => _SongGridState();
}

class _SongGridState extends State<SongGrid> {
  Song? randomSong;
  String message = "Press \"Generate\" to get a random song";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: SqlHelper().getSongs(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Song> songs = snapshot.data == null
                  ? <Song>[]
                  : snapshot.data as List<Song>;
              return ScrollConfiguration(
                behavior: RemoveScrollGlowBehaviour(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: songs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                      childAspectRatio: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder(
                        future: SqlHelper().checkGeneratedStatus(songs[index]),
                        builder: (_, AsyncSnapshot<bool> cardColorSnapshot) {
                          bool generatedStatus = cardColorSnapshot.data ?? false;
                          if (!widget.dontRepeat) generatedStatus = false;
                          return SizedBox(
                            height: 20,
                            child: Card(
                              color:
                                  generatedStatus ? Colors.grey[200] : Colors.white,
                              elevation: 5,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        songs[index].number.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: PopupMenuButton(
                                      icon: const Icon(Icons.more_vert, color: Colors.grey,),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 0,
                                          enabled: widget.dontRepeat,
                                          child: Text(
                                              generatedStatus ? "Uncheck" : "Check"),
                                        ),
                                        const PopupMenuItem(
                                          value: 1,
                                          child: Text("Delete song"),
                                        ),
                                      ],
                                      onSelected: (int item) {
                                        switch (item) {
                                          case 0:
                                            Song song = songs[index];
                                            song.alreadyGenerated = !generatedStatus;
                                            SqlHelper().updateSong(song);
                                            break;
                                          case 1:
                                            SqlHelper().deleteSong(songs[index]);
                                            break;
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Center(
                child: randomSong == null
                    ? Text(
                        message,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      )
                    : Text(
                        randomSong!.number.toString(),
                        style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                List<Song> songs = await SqlHelper().getSongs();
                if (widget.dontRepeat) {
                  songs = songs
                      .where((element) => !(element.alreadyGenerated))
                      .toList();
                }
                if (songs.isEmpty) {
                  setState(() {
                    randomSong = null;
                    message = "All songs have already been selected";
                  });
                  return;
                }
                randomSong = songs[Random().nextInt(songs.length)];
                if (widget.dontRepeat) {
                  randomSong!.alreadyGenerated = true;
                  await SqlHelper().updateSong(randomSong!);
                }
                setState(() {
                  randomSong = randomSong;
                });
              },
              child: const Text(
                "Generate",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class RemoveScrollGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
