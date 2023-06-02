import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHandler {
  //database name
  static const dbName = "todov.db";

  static const tableName = "todo";

  static const id = "id";
  static const title = "title";
  static const status = "status";
  static const createAt = "create_at";

  static const dbVersion = 2;

  static final DBHandler instance = DBHandler();

  Future<Database?> get database async {
    return await initDB();
  }

  initDB() async {
    //Database path
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    print("Path : $path");

    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE $tableName(
                $id INTEGER PRIMARY KEY AUTOINCREMENT,
                $title TEXT,
                $status BOOLEAN DEFAULT false,
                $createAt DATETIME
                )''');
    } catch (e) {
      log("Database create error : $e");
    }
  }

  //Update todo
  editTodo(Map<String, dynamic> row, String phoneNumber) async {
    try {
      Database? db = await instance.database;
      await db!
          .update(tableName, row, where: "$id = ?", whereArgs: [phoneNumber]);
    } catch (e) {}
  }

  //Change todo status
  changeStatus(int updateId, bool todoStatus) async {
    try {
      print("Id = $updateId , Status = $todoStatus");
      Database? db = await instance.database;
      await db!.rawQuery(
          "UPDATE $tableName SET $status = $todoStatus WHERE $id = $updateId");
    } catch (e) {
      print("Errors : $e");
    }
  }

  //Delete todo
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

  //Todos
  Future<List<Map<String, dynamic>>> todos() async {
    try {
      Database? db = await instance.database;
      return await db!.query(tableName, orderBy: "$id DESC");
    } catch (e) {
      return [];
    }
  }
}
