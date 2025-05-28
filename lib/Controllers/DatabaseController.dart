import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:skripsi/Data%20Model/user.dart';
import 'package:skripsi/GlobalVar.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController {
  static Database? db;
  static const String dbName = 'loginUser.db';
  static const String tableName = 'user';

  static int? status;

  Future<Database?> get database async {
    if (db != null) {
      return db;
    }
    db = await initDatabase();
    return db;
  }

  Future<Database?> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = join(await getDatabasesPath(), dbName);
    try {
      return openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $tableName(status INTEGER, user_id TEXT, user_name TEXT, user_role TEXT, user_email TEXT, phone_number TEXT)');
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int?> getStatus() async {
    final Database? db = await database;
    try {
      List<Map<String, dynamic>> result =
          await db!.rawQuery('SELECT * FROM $tableName');
      if (result.isNotEmpty) {
        GlobalVar.currentUser = user.fromJson(result.first);
        return status = result.first['status'] as int;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<user?> getUser() async {
    final Database? db = await database;
    try {
      List<Map<String, dynamic>> result =
          await db!.rawQuery('SELECT * FROM $tableName');
      if (result.isNotEmpty) {
        print(result.first);
        return user.fromJson(result.first);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> addStatus(int status, String user_id, String user_name,
      String user_role, String user_email, String phone_number) async {
    final Database? db = await database;
    try {
      List<Map<String, dynamic>> result =
          await db!.rawQuery('SELECT COUNT(*) as count FROM $tableName');
      int count = Sqflite.firstIntValue(result)!;
      if (count == 0) {
        await db.rawInsert(
            'INSERT INTO $tableName(status , user_id , user_name , user_role , user_email , phone_number) VALUES(?,?,?,?,?,?)',
            [status, user_id, user_name, user_role, user_email, phone_number]);
      } else {
        await db.rawUpdate(
            'UPDATE $tableName SET status = ?, user_id = ?, user_name  = ?, user_role = ?, user_email = ?, phone_number = ?',
            [status, user_id, user_name, user_role, user_email, phone_number]);
      }
    } catch (e) {}
  }

  Future<void> logOut() async {
    final Database? db = await database;
    try {
      await db!.rawDelete('DELETE FROM $tableName');
    } catch (e) {
      print('error message = $e');
    }
  }
}
