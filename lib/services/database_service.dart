// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:to_do_list/models/task_model.dart';

// class DatabaseService{
  
//   Future<Database> ConnectDatabase() async {
//     final databasePath = await getDatabasesPath();
//     final path = join(databasePath, 'database.db');

//     return await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//     // Create tables and perform any initialization if needed
//       await db.execute('CREATE TABLE to_do_list (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, complete TEXT)');
//   });
  
// }

//   void addToList(Task newTask) async{
//     final database = await ConnectDatabase();
//     await database.insert('to_do_list', {'task' : newTask.title, 'complete' : newTask.complete.toString()});
//   }

//   void getTaskList() {

//   }

// }

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/task_model.dart';

class DatabaseService {
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Database? _database;

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS to_do_list (
        id INTEGER PRIMARY KEY,
        task TEXT,
        complete TEXT
      )
    ''');
  }

  void addToList(Task newTask) async{
    final database = await instance.database;
    await database.insert('to_do_list', {'id' : newTask.task_ID,'task' : newTask.title, 'complete' : newTask.complete.toString()});
  }



  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await instance.database;
    return await db.query('to_do_list');
  }

  void printDataFromDatabase() async {
    // final dataList = await getAllData();
    // for (final data in dataList) {
    //   print('ID: ${data['id']}');
    //   print('title: ${data['task']}');
    //   print('completed : ${data['complete']}');
    //   print('-------------------------');
    // }
  }

  Future<int?> getLastEntryId() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT MAX(id) FROM to_do_list');
    final id = result.isNotEmpty ? result.first.values.first as int? : null;
    return id;
  }

  Future<void> deleteTask(int id) async {
    final db = await instance.database;
    await db.delete(
      'to_do_list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

    Future<void> deleteCompletedTasks() async {
    final db = await instance.database;
    await db.delete(
      'to_do_list',
      where: 'complete = ?',
      whereArgs: ['false'],
    );
  }

  Future<void> deleteAllData() async {
    final db = await instance.database;
    await db.delete('to_do_list');
  }

  
  Future<void> updateData(int id,bool complete) async {
    final db = await instance.database;
    await db.update(
      'to_do_list',
      {'complete': complete.toString()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<List<Task>> getAllTasks() async {
  // Open the database
    final Database db = await openDatabase('database.db');

  // Query all rows from the tasks table
    final List<Map<String, dynamic>> maps = await db.query('to_do_list');

  // Convert the List<Map> to List<Task>
    final List<Task> tasks = List.generate(maps.length, (index) {
    return Task(
      maps[index]['title'],
      maps[index]['complete']=='true', // Assuming complete is stored as an integer (1 for true, 0 for false)
      maps[index]['task_ID'],
    );
  });

  // Close the database
  await db.close();

  return tasks;
}



}
