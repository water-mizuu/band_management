// CREATE TABLE IF NOT EXISTS songs (
//   id INTEGER PRIMARY KEY,
//   name TEXT NOT NULL,
//   year INTEGER NOT NULL,
//   band_id INTEGER NOT NULL REFERENCES bands(id)
// );
extension type const Song._((int id, String name, int year, int bandId) _) {
  const Song({
    required int id,
    required String name,
    required int year,
    required int bandId,
  }) : this._((id, name, year, bandId));

  factory Song.fromMap(Map<String, dynamic> map) {
    var {"id": id, "name": name, "year": year, "band_id": bandId} = map;

    return Song(
      id: id,
      name: name,
      year: year,
      bandId: bandId,
    );
  }

  int get id => _.$1;
  String get name => _.$2;
  int get year => _.$3;
  int get bandId => _.$4;
}
