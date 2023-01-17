import 'package:sqflite/sqflite.dart';
import 'database_connection.dart';

class Repository{
  late DatabaseConnection _databaseConnection;

  Repository(){
    //initialize database connection
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async{
    if(_database!=null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  //Inserting data to Table
  insertData(table, data) async{
    var connection = await database;
    return await connection!.insert(table, data);
  }

  //Reading data from Table
  readData(table) async{
    var connection = await database;
    return await connection!.query(table);
  }

  readDataById(table, itemId) async{
    var connection = await database;
    return await connection!.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  updateData(table, data) async{
    var connection = await database;
    return await connection!.query(table, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteData(table, itemId) async{
    var connection = await database;
    return await connection!.rawDelete("DELETE FROM $table WHERE id= $itemId");
  }
}