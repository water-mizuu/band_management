import 'package:band_management/services/database_service.dart';
import 'package:band_management/structs/band.dart';
import 'package:band_management/structs/member.dart';
import 'package:band_management/structs/song.dart';
import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  factory AppState() => _instance;
  AppState._() {
    databaseService = DatabaseService();
  }

  late final DatabaseService databaseService;
  static final AppState _instance = AppState._();

  final List<Band> bands = <Band>[];
  final List<Member> members = <Member>[];
  final List<Song> songs = <Song>[];

  Future<void> initialize() async {
    await databaseService.initialize();

    /// Register the bands.
    for (var map in await databaseService.getBands()) {
      bands.add(Band.fromMap(map));
    }

    /// Register the members.
    for (var map in await databaseService.getMembers()) {
      members.add(Member.fromMap(map));
    }

    /// Register the songs.
    for (var map in await databaseService.getSongs()) {
      songs.add(Song.fromMap(map));
    }
  }

  // Create Methods
  Future<void> createBand({required String name, required String genreId}) async {
    int? id = await databaseService.createBand(name: name, genreId: genreId);
    if (id == null) return;

    bands.add(Band(
      id: id,
      name: name,
      genreId: genreId,
    ));

    notifyListeners();
  }

  Future<void> createMember({
    required String name,
    required int bandId,
    required String instrumentId,
  }) async {
    int? id = await databaseService.createMember(
      name: name,
      bandId: bandId,
      instrumentId: instrumentId,
    );
    if (id == null) return;

    members.add(Member(
      id: id,
      name: name,
      bandId: bandId,
      instrumentId: instrumentId,
    ));

    notifyListeners();
  }

  Future<void> createSong({
    required String name,
    required int bandId,
    required int year,
  }) async {
    int? id = await databaseService.createSong(
      name: name,
      bandId: bandId,
      year: year,
    );
    if (id == null) return;

    songs.add(Song(
      id: id,
      name: name,
      bandId: bandId,
      year: year,
    ));

    notifyListeners();
  }

  // Read Methods
  Band readBand(int id) {
    var call = bands.where((band) => band.id == id).toList();
    if (call case []) {
      throw Exception('Band not found');
    }

    return call.first;
  }

  List<Member> readMembers(int bandId) {
    return [
      for (var member in members)
        if (member.bandId == bandId) member
    ];
  }

  List<Song> readSongs(int bandId) {
    return [
      for (var song in songs)
        if (song.bandId == bandId) song
    ];
  }

  // Update Methods

  // Delete Methods
}
