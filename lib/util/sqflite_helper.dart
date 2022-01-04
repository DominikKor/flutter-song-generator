import 'dart:async';

import 'package:liedgenerator/models/song.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class SqlHelper {
  final String colId = 'id';
  final String colNumber = 'number';
  final String colFavourite = 'favourite';
  final String colAlreadyGenerated = 'alreadyGenerated';
  final String tableSongs = 'songs';

  static Database? _db;
  static final SqlHelper _singleton = SqlHelper._internal();
  final int version = 1;

  SqlHelper._internal();

  factory SqlHelper() {
    return _singleton;
  }

  Future<Database> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'songs.db');
    Database dbSongs =
        await openDatabase(dbPath, version: version, onCreate: _createDb);
    return dbSongs;
  }

  Future _createDb(Database db, int version) async {
    String query = 'CREATE TABLE $tableSongs ($colId INTEGER PRIMARY KEY, '
        '$colNumber INTEGER, $colFavourite INTEGER, '
        '$colAlreadyGenerated INTEGER)';
    await db.execute(query);
  }

  Future<List<Song>> getSongs() async {
    _db ??= await init();
    List<Map<String, dynamic>> songsList =
        await _db!.query(tableSongs, orderBy: colNumber);
    List<Song> songs = [];
    for (Map<String, dynamic> songMap in songsList) {
      songs.add(Song.fromMap(songMap));
    }
    return songs;
  }

  Future<int> insertSong(Song song) async {
    // Check if song already exists
    List<Song> songs = await getSongs();
    if (songs.any((element) => element.number == song.number)) return 0;

    int result = await _db!.insert(tableSongs, song.toMap());
    return result;
  }

  Future<int> updateSong(Song song) async {
    int result = await _db!.update(tableSongs, song.toMap(),
        where: '$colId = ?', whereArgs: [song.id]);
    return result;
  }

  Future<int> deleteSong(Song song) async {
    int result =
        await _db!.delete(tableSongs, where: '$colId = ?', whereArgs: [song.id]);
    return result;
  }

  Future<void> resetGeneratedStatus() async {
    await _db!.execute("UPDATE $tableSongs SET $colAlreadyGenerated = 0");
  }

  Future<bool> checkGeneratedStatus(Song song) async {
    List<Map<String, dynamic>> songsList =
        await _db!.query(tableSongs, where: '$colId = ?', whereArgs: [song.id]);
    int alreadyGenerated = songsList.first["alreadyGenerated"];
    return alreadyGenerated == 1 ? true : false;
  }
}
