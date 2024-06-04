import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'attendance_records'; // Changed table name

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'attendance_records.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $_tableName('
              'id INTEGER PRIMARY KEY,'
              'inTime TEXT,'
              'outTime TEXT,'
              'deviceId TEXT)', // Added column for device ID
        );
      },
    );
  }

  Future<void> insertAttendance(String inTime, String? outTime, String deviceId) async {
    final db = await database;

    // Get the current date in yyyy-MM-dd format
    String currentDate = DateTime.now().toString().substring(0, 10);

    // Check if an attendance record for the current date and device already exists
    List<Map<String, dynamic>> existingRecords = await db.query(
      _tableName,
      where: 'inTime LIKE ? AND deviceId = ?',
      whereArgs: ['$currentDate%', deviceId],
    );

    if (existingRecords.isEmpty) {
      // No existing record found, insert a new attendance record
      await db.insert(
        _tableName,
        {'inTime': inTime, 'outTime': null, 'deviceId': deviceId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Update the existing record with the new inTime
      int existingRecordId = existingRecords.first['id'];
      await db.update(
        _tableName,
        {'inTime': inTime},
        where: 'id = ?',
        whereArgs: [existingRecordId],
      );
    }
  }

  // Future<void> insertAttendance(String inTime, String? outTime, String deviceId) async {
  //   final db = await database;
  //   await db.insert(
  //     _tableName,
  //     {'inTime': inTime, 'outTime': null, 'deviceId': deviceId},
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }


  Future<void> updateOutTime(int id, String outTime) async {
    final db = await database;
    await db.update(
      _tableName,
      {'outTime': outTime},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAttendanceForToday(String deviceId) async {
    final db = await database;

    // Get the current date in yyyy-MM-dd format
    String currentDate = DateTime.now().toString().substring(0, 10);

    return await db.query(
      _tableName,
      where: 'deviceId = ? AND inTime LIKE ?',
      whereArgs: [deviceId, '$currentDate%'],
    );
  }

  Future<List<Map<String, dynamic>>> getAttendanceByDeviceId(String deviceId) async {
    final db = await database;
    return await db.query(
      _tableName,
      where: 'deviceId = ?',
      whereArgs: [deviceId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllAttendance() async {
    final db = await database;
    return await db.query(_tableName);
  }
  Future<void> deleteAttendanceById(String deviceId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'deviceId = ?',
      whereArgs: [deviceId],
    );
  }

  Future<void> deleteAllAttendance() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
