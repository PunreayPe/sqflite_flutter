import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      desc TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
    )""");
  }

// Create db
  static Future<sql.Database> db() async {
    return sql.openDatabase("database_name.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

// Create data
  static Future<int> createData(String title, String? desc) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'desc': desc};
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

// Get data from key
  static Future<List<Map<String, dynamic>>> getAlldata() async {
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
  }

// Get single data
  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
  }

//Update Data
  static Future<int> updateData(int id, String title, String? desc) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'desc': desc,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('data', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete data
  static Future<void> deleteData(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('data', where: "id = ?", whereArgs: [id]);
    } catch (e) {}
  }
}