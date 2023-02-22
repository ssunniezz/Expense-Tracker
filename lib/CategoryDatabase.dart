import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Category {
  final int? id;
  final String name;
  final double expense;

  Category({this.id, required this.name, required this.expense});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name'], expense: json['expense']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'expense': expense,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Category &&
            other.id == id);
  }
}

class Log {
  final int? id;
  final int categoryId;
  final String note;
  final double expense;

  Log({this.id, required this.categoryId, required this.expense, required this.note});

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(id: json['id'], categoryId: json['categoryId'], expense: json['expense'], note: json['note']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'note': note,
      'expense': expense,
    };
  }
}


class CategoryDB {
  CategoryDB._privateConstructor();

  static final CategoryDB instance = CategoryDB._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    return _database ?? await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'category.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: _onOpen,
    );
  }

  Future _onOpen(Database db) async {
    db.execute("PRAGMA foreign_keys=ON");
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY,
        name TEXT,
        expense REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE logs(
        id INTEGER PRIMARY KEY,
        categoryId INTEGER,
        note TEXT,
        expense REAL,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');
    await db.insert('categories', Category(id: 1, name: "Budget",expense: 1000).toJson());
  }

  Future<List<Category>> getCategories() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> categories = await db.query('categories', orderBy: 'expense DESC');

    List<Category> categoryList = categories.isNotEmpty ? categories.map((c) => Category.fromJson(c)).toList() : [];
    return categoryList;
  }

  Future<int> insert(Category category) async {
    Database db = await instance.database;
    return await db.insert('categories', category.toJson());
  }

  Future<int> update(Category category) async {
    Database db = await instance.database;
    return await db.update('categories', category.toJson(), where: 'id = ?', whereArgs: [category.id]);
  }

   void resetAll(List<Category> categories) async {
    Database db = await instance.database;
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (Category category in categories) {
        batch.update('categories', category.toJson(), where: 'id = ?', whereArgs: [category.id]);
      }
      batch.delete('logs');

      await batch.commit(noResult: true);
    });
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }


  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.rawDelete('DELETE FROM categories WHERE NOT id = ?', [1]);
  }

  Future<int> insertLog(Log log) async {
    Database db = await instance.database;
    return await db.insert('logs', log.toJson());
  }

  Future<List<Log>> getLogsByCategoryId(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> logs = await db.query(
        'logs', where: 'categoryId = ?', whereArgs: [id], orderBy: 'id DESC');

    List<Log> logList = logs.isNotEmpty ? logs.map((c) => Log.fromJson(c))
        .toList() : [];
    return logList;
  }
}
