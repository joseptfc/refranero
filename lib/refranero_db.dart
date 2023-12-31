import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Refran {
  final int id;
  final String texto;
  final bool completado;
  final int color;

  Refran({
    required this.id,
    required this.texto,
    required this.completado,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texto': texto,
      'completado': completado ? 1 : 0,
      'color': color,
    };
  }
}

class RefranesDatabase {
  static final RefranesDatabase instance = RefranesDatabase._init();
  static Database? _database;
  RefranesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('refranes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDB,
    );
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE refranes_items(
        id INTEGER PRIMARY KEY,
        texto TEXT,
        completado BOOLEAN 0,
        color INTEGER 0
      )
    ''');
  }

  Future<int> create(Refran refran) async {
    final db = await database;
    return db.insert('refranes_items', refran.toMap());
  }

  Future<List<Refran>> getAllRefranes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('refranes_items');
    return List.generate(maps.length, (i) {
      return Refran(
        id: maps[i]['id'],
        texto: maps[i]['texto'],
        completado: maps[i]['completado'] == 1,
        color: maps[i]['color'],
      );
    });
  }

  Future<int> update(Refran refran) async {
    final db = await database;
    return db.update(
      'refranes_items',
      refran.toMap(),
      where: 'id = ?',
      whereArgs: [refran.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(
      'refranes_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
