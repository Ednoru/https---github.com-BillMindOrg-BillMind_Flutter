import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static int version = 1;
  static String dbName = 'billmind.db';
  static String tableClient = 'client';
  static String tableDebt = 'debt';
  static Database? _db;

  static Future<Database> openDB() async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), dbName),
      version: version,
      onCreate: (db, version) async {
        String query = '''
        create table $tableClient (
          id integer primary key autoincrement,
          name text, 
          last_name text, 
          mail text, 
          phone text, 
          password text
        );
        create table $tableDebt (
          id integer primary key autoincrement,
          clientId integer, 
          amount real, 
          expiration text, 
          description text,
          relevance text, 
          foreign key (clientId) references $tableClient(id)
        );
        ''';
        await db.execute(query);
      },
    );
    return _db as Database;
  }
}
