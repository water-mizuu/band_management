import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  factory DatabaseService() => _instance;
  DatabaseService._();

  static final DatabaseService _instance = DatabaseService._();

  Database? _database;
  bool hasInitialized = false;

  Future<void> initialize() async {
    if (hasInitialized || _database != null) {
      return;
    }

    try {
      String path = join(await getDatabasesPath(), "app_database.db");
      _database = await openDatabase(
        path,
        version: 2,
        onUpgrade: (database, __, ___) async {
          await database.execute('DROP TABLE IF EXISTS bands;');
          await database.execute('DROP TABLE IF EXISTS members;');
          await database.execute('DROP TABLE IF EXISTS songs;');
        },
      );

      /// bands:
      ///   - id: int primary key
      ///   - name: str
      ///   - genre_id: str
      ///
      /// members:
      ///   - id: int primary key
      ///   - name: str
      ///   - instrument_id: str
      ///   - band_id: int foreign key references bands(id)
      ///
      /// songs:
      ///   - id: int primary key
      ///   - name: str
      ///   - year: int
      ///   - band_id: int foreign key references bands(id)

      await _database!.execute('''
        CREATE TABLE IF NOT EXISTS bands (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          genre_id TEXT NOT NULL
        );
      ''');

      await _database!.execute('''
        CREATE TABLE IF NOT EXISTS members (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          instrument_id TEXT NOT NULL,
          band_id INTEGER NOT NULL REFERENCES bands(id)
        );
      ''');

      await _database!.execute('''
        CREATE TABLE IF NOT EXISTS songs (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          year INTEGER NOT NULL,
          band_id INTEGER NOT NULL REFERENCES bands(id)
        );
      ''');

      hasInitialized = true;
    } on Object catch (e) {
      if (kDebugMode) {
        print("Error initializing database: $e");
        rethrow;
      }
    }
  }

  // Create
  Future<int?> createBand({required String name, required String genreId}) async {
    if (_database case Database database) {
      int id = await database.insert('bands', {
        'name': name,
        'genre_id': genreId,
      });

      return id;
    }

    return null;
  }

  Future<int?> createMember({
    required String name,
    required String instrumentId,
    required int bandId,
  }) async {
    if (_database case Database database) {
      int id = await database.insert('members', {
        'name': name,
        'instrument_id': instrumentId,
        'band_id': bandId,
      });

      return id;
    }

    return null;
  }

  // id INTEGER PRIMARY KEY,
  // name TEXT NOT NULL,
  // year INTEGER NOT NULL,
  // band_id INTEGER NOT NULL REFERENCES bands(id)
  Future<int?> createSong({
    required String name,
    required int year,
    required int bandId,
  }) async {
    if (_database case Database database) {
      int id = await database.insert('songs', {
        'name': name,
        'year': year,
        'band_id': bandId,
      });

      return id;
    }

    return null;
  }

  // Read
  Future<List<Map<String, Object?>>> getBands() async {
    if (_database case var database?) {
      return await database.query('bands');
    }

    return [];
  }

  Future<List<Map<String, Object?>>> getMembers() async {
    if (_database case var database?) {
      return await database.query('members');
    }

    return [];
  }

  Future<List<Map<String, Object?>>> getSongs() async {
    if (_database case var database?) {
      return await database.query('songs');
    }

    return [];
  }

  // Update

  // Delete
  Future<void> deleteBand(int id) async {
    if (_database case var database?) {
      await database.delete('bands', where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<void> deleteMember(int id) async {
    if (_database case var database?) {
      await database.delete('members', where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<void> deleteSong(int id) async {
    if (_database case var database?) {
      await database.delete('songs', where: 'id = ?', whereArgs: [id]);
    }
  }
}
