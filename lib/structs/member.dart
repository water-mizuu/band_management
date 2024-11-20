// CREATE TABLE IF NOT EXISTS members (
//   id INTEGER PRIMARY KEY,
//   name TEXT NOT NULL,
//   instrument_id TEXT NOT NULL,
//   band_id INTEGER NOT NULL REFERENCES bands(id)
// );
extension type const Member._((int id, String name, String instrumentId, int bandId) _) {
  const Member({
    required int id,
    required String name,
    required String instrumentId,
    required int bandId,
  }) : this._((id, name, instrumentId, bandId));

  factory Member.fromMap(Map<String, dynamic> map) {
    var {"id": id, "name": name, "instrument_id": instrumentId, "band_id": bandId} = map;

    return Member(
      id: id,
      name: name,
      instrumentId: instrumentId,
      bandId: bandId,
    );
  }

  int get id => _.$1;
  String get name => _.$2;
  String get instrumentId => _.$3;
  int get bandId => _.$4;
}
