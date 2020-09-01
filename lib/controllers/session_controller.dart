import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/session.dart';

class SessionController {
  var database;

  static final SessionController _sessionController =
      SessionController._internal();

  factory SessionController() {
    return _sessionController;
  }

  SessionController._internal();

  Future<Database> setDatabase() async {
    this.database = await openDatabase(
      join(await getDatabasesPath(), 'sessions_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE sessions(id INTEGER PRIMARY KEY, count INTEGER)",
        );
      },
      version: 1,
    );
    return this.database;
  }

  Future<void> insertSession(Session session) async {
    final Database db = await database;

    await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Session>> getSessions() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('sessions');

    return List.generate(maps.length, (i) {
      return Session(
        id: maps[i]['id'],
        count: maps[i]['count'],
      );
    });
  }

  Future<void> deleteSession(int id) async {
    final db = await database;

    await db.delete(
      'sessions',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
