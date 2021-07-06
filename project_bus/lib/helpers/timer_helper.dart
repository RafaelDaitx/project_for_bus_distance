import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

//definindo as colunas, final não permite modificar valor da String
String timerTable = "timerTable";
String idColumn = "idColumn";
String schoolInColumn = "schoolInColumn";
String dateColumn = "dayColumn";
String quilometerInColumn = "quilometerInColumn";
String quilometerOutColumn = "quilometerOutColumn";
String quilometerAllColumn = "quilometerAlltColumn";

class TimerHelper {
  static final TimerHelper _instance = TimerHelper.internal();

  factory TimerHelper() => _instance;

  TimerHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "timernew3.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $timerTable($idColumn INTEGER PRIMARY KEY, $schoolInColumn TEXT,$dateColumn TEXT, $quilometerInColumn TEXT,"
          "$quilometerOutColumn TEXT, $quilometerAllColumn TEXT)");
    });
  }

  Future<Timer> saveTimer(Timer timer) async {
    Database dbTimer = await db; //obtendo o banco de dados
    timer.id = await dbTimer.insert(
        timerTable, timer.toMap()); //salvando o dado no banco
    return timer;
  }

  Future<Timer> getTimer(int id) async {
    Database dbTimer = await db; //obtendo o banco de dados
    List<Map> maps = await dbTimer.query(timerTable,
        columns: [
          idColumn,
          schoolInColumn,
          dateColumn,
          quilometerInColumn,
          quilometerOutColumn,
          quilometerAllColumn
        ],
        where: "$idColumn ?",
        whereArgs: [id]); //procurando  o "contato"
    if (maps.length > 0) {
      return Timer.fromMap(maps.first);
    } else
      return null;
  }

  Future<int> deleteTimer(int id) async {
    Database dbTimer = await db; //obtendo o banco de dados
    return await dbTimer
        .delete(timerTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateTimer(Timer timer) async {
    Database dbTimer = await db; //obtendo o banco de dados
    return await dbTimer.update(timerTable, timer.toMap(),
        where: "$idColumn = ?", whereArgs: [timer.id]);
  }

  Future<List> getAllTimer() async {
    Database dbTimer = await db; //obtendo o banco de dados
    List listMap = await dbTimer.rawQuery("SELECT * FROM $timerTable");
    //buscando todos dados da tabela
    List<Timer> listTimer = List();
    for (Map m in listMap) {
      listTimer.add(Timer.fromMap(m));
    }
    return listTimer;
  }

  Future<int> getNumber() async {
    Database dbTimer = await db; //obtendo o banco de dados
    return Sqflite.firstIntValue(
        await dbTimer.rawQuery("SELECT COUNT(*) FROM $timerTable"));
    //retoranndo a quantidade de rotas na tabela
  }

  Future close() async {
    Database dbTimer = await db; //obtendo o banco de dados
    dbTimer.close();
    //fechar o banco de dados
  }
}

class Timer {
  int id;
  String schoolIn;
  String date;
  String quilometerIn;
  String quilometerOut;
  String quilometerAll;

  Timer();

  Timer.fromMap(Map map) {
    id = map[idColumn];
    schoolIn = map[schoolInColumn];
    date = map[dateColumn];
    quilometerIn = map[quilometerInColumn];
    quilometerOut = map[quilometerOutColumn];
    quilometerAll = map[quilometerAllColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      schoolInColumn: schoolIn,
      dateColumn: date,
      quilometerInColumn: quilometerIn,
      quilometerOutColumn: quilometerOut,
      quilometerAllColumn: quilometerAll
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Timer(id: $id, school $schoolIn, date $date, quilometerIn $quilometerIn, quilometerOut $quilometerOut, quilometerAll $quilometerAll"
        ")";
  }
}
