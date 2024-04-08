import 'dart:async';
import 'dart:developer';
// import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:vlc_msg_app/models/contact.dart';
// import 'package:vlc_msg_app/models/msg.dart';
// import 'package:vlc_msg_app/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    _db ??= await init();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> init() async {

    try {

      // io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
      // String path = join(documentsDirectory.path, "main.db");
      String documentsDirectory = await getDatabasesPath();
      String path = join(documentsDirectory, "main.db");
      log(path);
      return openDatabase(
        path, 
        version: 1, 
        onCreate: onCreate
      );
    } 
		on MissingPlatformDirectoryException catch (e) {

			log('Error: $e');
			return Future.error(e);
    }
  }

  void onCreate(Database db, int version) async {

    await db.execute(
      'CREATE TABLE user (name STRING NOT NULL, privateKey STRING NOT NULL, publicKey STRING NOT NULL, mobileUnlock BOOLEAN DEFAULT FALSE); CREATE TABLE contact (id STRING PRIMARY KEY NOT NULL, name STRING NOT NULL, publicKey STRING NOT NULL); CREATE TABLE messages (id STRING PRIMARY KEY, timestamp TIMESTAMP NOT NULL, text TEXT NOT NULL);'
    );
    // await db.execute(
    //   'CREATE TABLE contact (id STRING PRIMARY KEY NOT NULL, name STRING NOT NULL, publicKey STRING NOT NULL)'
    // );
    // await db.execute(
    //   'CREATE TABLE messages (id STRING PRIMARY KEY, timestamp TIMESTAMP NOT NULL, text TEXT NOT NULL)'
    // );
  }

  // Future<List<Map<String, dynamic>>> query(String table) async => (await db).query(table);

  // Future<int> insert(String table, BaseModel model) async => (await db).insert(table, model.toMap());

  // Future<int> update(String table, BaseModel model) async => (await db).update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  // Future<int> delete(String table, BaseModel model) async => (await db).delete(table, where: 'id = ?', whereArgs: [model.id]);
}