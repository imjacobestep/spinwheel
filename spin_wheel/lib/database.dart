import 'dart:math';
import 'package:spin_wheel/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

List<OptionList> listList = [];
List<Option> options = [];

int randomInt(){
  var random = Random();
  return random.nextInt(200000000);
}

bool listExists(OptionList l){
  for(int i = 0; i < listList.length; i++){
    if(listList[i].listID == l.listID){
      return true;
    }
  }
  return false;
}

Future<void> initStore() async {
  List<OptionList> oL = await DBProvider.db.getLists();
  listList = oL;
}

class DBProvider {

  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'spinWheel.db'),
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE option_lists (
          listID INTEGER PRIMARY KEY, listName TEXT
          );
        ''');
          await db.execute('''
          CREATE TABLE options (
          listID INTEGER, optionText TEXT,
          FOREIGN KEY (listID) REFERENCES option_lists(listID)
          );
        ''');
        },
        version: 1
    );
  }

  Future<void> newList(OptionList l) async {
    final db = await database;
    await db.insert('option_lists', {'listID': l.listID, 'listName': l.listName});
    for(int i = 0; i < l.options.length; i++){
      newOption(l.options[i]);
    }
    listList.add(l);
  }

  Future<void> deleteList(OptionList l) async {
    final db = await database;
    listList.removeWhere((OptionList) => OptionList.listID == l.listID);
    await db.delete('option_lists', where: 'listId = ?', whereArgs: [l.listID]);
  }

  Future<void> updateList(OptionList l) async {
    await deleteList(l);
    await clearOptions(l.listID);
    await newList(l);
    for(int i = 0; i < l.options.length; i++){
      newOption(l.options[i]);
    }
  }

  Future<List<OptionList>> getLists() async {
    final db = await database;
    List<Map> maps = await db.query('option_lists', columns: ['listID', 'listName']);
    List<OptionList> listList = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        listList.add(OptionList.fromMap(maps[i]));
        List<Option> options = await getOptions(listList[i].listID);
        listList[i].setOptions(options);
      }
    }
    return listList;
  }

  Future<void> newOption(Option o) async {
    final db = await database;
    await db.insert('options', {'listID': o.listID, 'optionText': o.optionText});
  }

  Future<void> deleteOption(Option o) async {
    final db = await database;
    await db.delete('options', where: 'optionText = ?', whereArgs: [o.optionText]);
  }

  Future<void> clearOptions(int listID) async {
    final db = await database;
    await db.delete('options', where: 'optionText = ?', whereArgs: [listID]);
  }

  Future<List<Option>> getOptions(int listID) async {
    final db = await database;
    List<Map> maps = await db.query('options', where: 'listID = ?', whereArgs: [listID]);
    List<Option> optionList = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        optionList.add(Option.fromMap(maps[i]));
      }
    }
    return optionList;
  }

}