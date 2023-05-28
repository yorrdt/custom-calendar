import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_schedule/model/schedule.dart';

class ScheduleDatabase {
  static final ScheduleDatabase instance = ScheduleDatabase._init();

  static Database? _database;

  ScheduleDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('schedule_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String textType = 'TEXT NOT NULL';

    await db.execute("CREATE TABLE $tableSchedule ("
        "${ScheduleFields.id} $idType,"
        "${ScheduleFields.title} $textType,"
        "${ScheduleFields.createdTime} $textType"
        ")");
  }

  Future<Schedule> create(Schedule schedule) async {
    final db = await instance.database;

    final id = await db.insert(tableSchedule, schedule.toJson());
    return schedule.copy(id: id);
  }

  Future<Schedule> readScheduleItem(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableSchedule,
      columns: ScheduleFields.values,
      where: '${ScheduleFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Schedule.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Schedule>> readSchedule() async {
    final db = await instance.database;

    const orderBy = '${ScheduleFields.id} ASC';
    final result = await db.query(tableSchedule, orderBy: orderBy);

    return result.map((json) {
      return Schedule.fromJson(json);
    }).toList();
  }

  Future<List<Schedule>> readScheduleRange(DateTime dt) async {
    final db = await instance.database;

    final result = await db.rawQuery("SELECT * FROM $tableSchedule "
        "WHERE ${ScheduleFields.createdTime} "
        "BETWEEN DATETIME('${DateTime(dt.year, dt.month, dt.day)}') AND  "
        "DATETIME('${DateTime(dt.year, dt.month, dt.day + 1)}')");

    return result.map((json) {
      return Schedule.fromJson(json);
    }).toList();
  }

  Future<int> update(Schedule schedule) async {
    final db = await instance.database;

    return db.update(
      tableSchedule,
      schedule.toJson(),
      where: '${ScheduleFields.id} = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableSchedule,
      where: '${ScheduleFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
