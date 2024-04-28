import 'dart:async';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vlc_msg_app/models/user.dart';
import 'package:vlc_msg_app/models/contact.dart';
import 'package:vlc_msg_app/models/msg.dart';
import 'package:vlc_msg_app/utils/rsa.dart';

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

      String documentsDirectory = await getDatabasesPath();
      String path = join(documentsDirectory, "vlc.db");
      
      return openDatabase(
        path, 
        version: 1, 
        onCreate: onCreate
      );
    } 
		on Exception catch (e) {

			log('Error: $e');
			return Future.error(e);
    }
  }

  void onCreate(Database db, int version) async {

    await db.execute('CREATE TABLE user (name STRING NOT NULL, privateKey STRING NOT NULL, publicKey STRING NOT NULL, mobileUnlock BOOLEAN DEFAULT FALSE)');
    await db.execute('CREATE TABLE contacts (id STRING PRIMARY KEY NOT NULL, name STRING NOT NULL, publicKey STRING NOT NULL)');
    await db.execute('CREATE TABLE messages (id STRING PRIMARY KEY NOT NULL, timestamp TIMESTAMP NOT NULL, text TEXT NOT NULL)');
  }

  // Drop all tables and recreate them
  Future<void> resetDatabase() async {

    try {

      Database db = await this.db;

      await db.transaction((txn) async {
        await txn.execute('DROP TABLE IF EXISTS user');
        await txn.execute('DROP TABLE IF EXISTS contact');
        await txn.execute('DROP TABLE IF EXISTS messages');
        onCreate(db, 1);
      });
    } 
    catch (e) {

      log('Error resetting database: $e');
      throw Exception('Failed to reset database');
    }
  }

  // Get all table names
  void getTableNames() async {

    try {
      Database db = await this.db;
      List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );
      // log the list of tables one by one
      for (var table in tables) {
        log('Table: ${table['name']}');
      }
    } catch (e) {
      log('Error getting table names: $e');
      throw Exception('Failed to get table names');
    }
  }

  // #User Methods

  // Save User
  Future<int> saveUser(User user) async {

    final Map<String, String> keyPair = await RSAUtils.generateKeyPair();
    user.privateKey = keyPair['privateKey']!;
    user.publicKey = keyPair['publicKey']!;

    try {

      Database db = await this.db;
      int result = await db.insert('user', user.toMap());
      return result;
    } 
    catch (e) {

      log('Error saving user: $e');
      throw Exception('Failed to save user');
    }
  }

  // Update User
  Future<int> updateUser(User user) async {

    try {

      Database db = await this.db;
      int result = await db.update('user', user.toMap());
      return result;
    } 
    catch (e) {

      log('Error updating user: $e');
      throw Exception('Failed to update user');
    }
  }

  // Get User
  Future<User> getUser() async {

    try {

      Database db = await this.db;
      List<Map<String, dynamic>> users = await db.query('user');

      if (users.isNotEmpty) {
        log('User found');
        //log user
        // log(users.first.toString());
        return User.fromMap(users.first);
      }

      log('No existing User found');
      throw Exception('No existing User found');
    } 
    catch (e) {

      log('Error getting user: $e');
      throw Exception('Failed to get user');
    }
  }

  // Empty the User table
  Future<int> emptyUser() async {

    try {

      Database db = await this.db;
      int result = await db.delete('user');
      log('User table emptied');
      return result;
    } 
    catch (e) {

      log('Error emptying user: $e');
      throw Exception('Failed to empty user');
    }
  }

  // #Contacts Methods

  // Save Contact
  Future<int> saveContact(Contact contact) async {

    try {

      Database db = await this.db;
      List<Map<String, dynamic>> existingContacts = await db.query('contacts', where: 'publicKey = ?', whereArgs: [contact.publicKey]);

      if (existingContacts.isNotEmpty) {
        throw Exception('Contact with public key already exists');
      }

      int result = await db.insert('contacts', contact.toMap());
      return result;
    } 
    catch (e) {

      log('Error saving contact: $e');
      throw Exception('Failed to save contact');
    }
  }

  // Get Contacts
  Future<List<Contact>> getContacts() async {

    try {

      Database db = await this.db;
      List<Map<String, dynamic>> contacts = await db.query('contacts');

      if (contacts.isNotEmpty) {
        return contacts.map((contact) => Contact.fromMap(contact)).toList();
      }

      log('No Existing Contacts Found');
      throw Exception('No Existing Contacts Found');
    } 
    catch (e) {

      log('Error getting contacts: $e');
      throw Exception('Failed to get contacts');
    }
  }

  // Get Contact by id
  Future<Contact> getContactById(String id) async {

    try {

      Database db = await this.db;
      List<Map<String, dynamic>> contacts = await db.query('contacts', where: 'id = ?', whereArgs: [id]);

      if (contacts.isNotEmpty) {
        return Contact.fromMap(contacts.first);
      }

      log('No exsisting Contact found');
      throw Exception('No exsisting Contact found');
    } 
    catch (e) {

      log('Error getting contact: $e');
      throw Exception('Failed to get contact');
    }
  }

  // Delete Contact by id
  Future<int> deleteContactById(String id) async {

    try {

      Database db = await this.db;
      int result = await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
      return result;
    } 
    catch (e) {

      log('Error deleting contact: $e');
      throw Exception('Failed to delete contact');
    }
  }

  // #Messages Methods

  // Save Message
  Future<int> saveMessage(Message msg) async {

    try {

      Database db = await this.db;
      int result = await db.insert('messages', msg.toMap());
      return result;
    } 
    catch (e) {

      log('Error saving message: $e');
      throw Exception('Failed to save message');
    }
  }

  // Get Messages
  Future<List<Message>> getMessages() async {

    try {

      Database db = await this.db;
      List<Map<String, dynamic>> messages = await db.query('messages');

      if (messages.isNotEmpty) {
        return messages.map((message) => Message.fromMap(message)).toList() as List<Message>;
      }

      log('No exsisting Messages found');
      throw Exception('No exsisting Messages found');
    } 
    catch (e) {

      log('Error getting messages: $e');
      throw Exception('Failed to get messages');
    }
  }

  // Delete Message by id
  Future<int> deleteMessageById(String id) async {

    try {

      Database db = await this.db;
      int result = await db.delete('messages', where: 'id = ?', whereArgs: [id]);
      return result;
    } 
    catch (e) {

      log('Error deleting message: $e');
      throw Exception('Failed to delete message');
    }
  }
}