import 'package:flutter/material.dart';
import 'package:liedgenerator/models/song.dart';
import 'package:liedgenerator/screens/about.dart';
import 'package:liedgenerator/util/sqflite_helper.dart';
import 'package:liedgenerator/widgets/add_song.dart';
import 'package:liedgenerator/widgets/song_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Song Generator"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text("Reset Generated Songs"),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text("About"),
              ),
            ],
            onSelected: (int item) {
              switch (item) {
                case 0:
                  SqlHelper().resetGeneratedStatus();
                  break;
                case 1:
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const AboutScreen();
                  }));
                  break;
              }
              setState(() {});
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.crop_square_outlined),
            label: "Generator",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            label: "Quick Generator",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add",
          ),
        ],
      ),
      body: [
        SongGrid(dontRepeat: true, key: UniqueKey()),
        SongGrid(dontRepeat: false, key: UniqueKey()),
        AddSong(),
      ][_selectedIndex],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
