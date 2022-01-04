class Song {
  int? id;
  late int number;
  late bool favourite;
  late bool alreadyGenerated;

  Song(this.number, this.favourite, this.alreadyGenerated);

  Song.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    number = map["number"];
    favourite = map["favourite"] == 1 ? true : false;
    alreadyGenerated = map["alreadyGenerated"] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return {
      "number": number,
      "favourite": favourite ? 1 : 0,
      "alreadyGenerated": alreadyGenerated ? 1 : 0
    };
  }
}
