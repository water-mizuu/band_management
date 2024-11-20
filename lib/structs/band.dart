extension type const Band._((int id, String name, String genreId) _) {
  const Band({
    required int id,
    required String name,
    required String genreId,
  }) : this._((id, name, genreId));

  factory Band.fromMap(Map<String, dynamic> map) {
    var {"id": id, "name": name, "genre_id": genreId} = map;
    return Band(
      id: id,
      name: name,
      genreId: genreId,
    );
  }

  int get id => _.$1;
  String get name => _.$2;
  String get genreId => _.$3;
}
