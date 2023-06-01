import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHandler {
  //database name
  static const dbName = "todo.db";

  static const tableName = "todo";

  static const id = "id";
  static const title = "title";
  static const status = "status";
  static const atCreate = "at_create";

  static const dbVersion = 1;

  static final DBHandler instance = DBHandler();

  Future<Database?> get database async {
    return await initDB();
  }

  initDB() async {
    //Android database path
    Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, dbName);

    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE $tableName(
                $id TEXT PRIMARY KEY AUTOINCREMENT,
                $title TEXT,
                $status BOOLEAN,
                $atCreate DATETIME
                )''');
    } catch (e) {
      log("Database create error : $e");
    }
  }

  //Update do
  editTodo(Map<String, dynamic> row, String phoneNumber) async {
    try {
      Database? db = await instance.database;
      await db!
          .update(tableName, row, where: "$id = ?", whereArgs: [phoneNumber]);
    } catch (e) {}
  }

  //Update do
  void deleteTodo(int index) async {
    try {
      Database? db = await instance.database;
      await db!.delete(tableName, where: "$id = $index");
    } catch (e) {}
  }

  //Insert new todo
  void addTodo(Map<String, dynamic> row) async {
    try {
      Database? db = await instance.database;
      await db!.insert(tableName, row);
    } catch (e) {}
  }
}
