import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vlc_msg_app/db/db_helper.dart';
import 'package:vlc_msg_app/pages/message_history.dart';
import 'package:vlc_msg_app/pages/splash_screen.dart';


Future<void> main() async {

	WidgetsFlutterBinding.ensureInitialized();

	sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

	final DatabaseHelper dbh = DatabaseHelper();
	final Future<Database> db = DatabaseHelper().db;
	
	runApp(MyApp(database: await db));
}

class MyApp extends StatelessWidget {

	final Database database;

  const MyApp({super.key, required this.database});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const MsgHistory(),
    );
  }
}
