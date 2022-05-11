import 'package:keep_notes/services/firestore_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/MyNoteModel.dart';
class NotesDatabse {
  static final NotesDatabse instance = NotesDatabse._init();
  static Database? _database;
  NotesDatabse._init();

  Future<Database?> get database async{
    if(_database != null) return _database;
    _database = await _initializeDB('Notes.db');
    return _database;
  }


  Future<Database> _initializeDB(String filepath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath , filepath);

    return await openDatabase(path , version:  1, onCreate: _createDB );
  }


  Future _createDB(Database db, int version) async {
    final idType  = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = ' BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';
    final key = 'TEXT UNIQUE NOT NULL';
    await db.execute('''
    CREATE TABLE Notes(
      ${NotesImpNames.id} $idType,
      ${NotesImpNames.uniqueID} $key,
      ${NotesImpNames.pin} $boolType,
      ${NotesImpNames.isArchive} $boolType,
      ${NotesImpNames.title} $textType,
      ${NotesImpNames.content} $textType,
      ${NotesImpNames.noteColor} $textType,
      ${NotesImpNames.createdTime} $textType
    )
    ''');
    //(${NotesImpNames.pin} IN (0, 1))
    //(${NotesImpNames.isArchive} IN (0, 1))
  }

  Future<Note?> insertEntry(Note note) async{
    final db = await instance.database;
    try {
      final id = await db!.insert(NotesImpNames.TableName, note.toJson(), conflictAlgorithm: ConflictAlgorithm.rollback);
      await FireDB().createNewNoteFirestore(note);
      return note.copy(id: id);
    }
    on DatabaseException
    {
      print('Exception resolved successfully');
    }
  }

  Future<List<Note>> readAllNotes() async{
    final db = await instance.database;
    final orderBy = '${NotesImpNames.pin} DESC, ${NotesImpNames.createdTime} DESC';
    final queryResult = await db!.query(NotesImpNames.TableName, where: '${NotesImpNames.isArchive} = 0', orderBy: orderBy);
    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> readAllArchiveNotes() async{
    final db = await instance.database;
    final orderBy = '${NotesImpNames.pin} DESC, ${NotesImpNames.createdTime} DESC';
    final queryResult = await db!.query(NotesImpNames.TableName, where: '${NotesImpNames.isArchive} = 1', orderBy: orderBy);
    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note?> readOneNote(int id) async{
    final db = await instance.database;
    final map = await db!.query(NotesImpNames.TableName ,
        columns: NotesImpNames.values ,
        where: '${NotesImpNames.id} = ?',
        whereArgs: [id]
    );
    if(map.isNotEmpty){
      return Note.fromJson(map.first);
    }else{
      return null;
    }
  }

  Future<List<int>> getNoteString(String query) async{
    final db = await instance.database;
    final result = await db!.query(NotesImpNames.TableName);
    List<int> resultIds = [];
    for (var element in result) {
      if(element["title"].toString().toLowerCase().contains(query) || element["content"].toString().toLowerCase().contains(query)){
        resultIds.add(element["id"] as int);
      }
    }
    return resultIds;
  }

  Future updateNote(Note note) async{
    await FireDB().updateNoteFirestore(note);
    final db = await instance.database;

    await db!.update(NotesImpNames.TableName, note.toJson(), where:  '${NotesImpNames.id} = ?' ,whereArgs: [note.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future pinNote(Note note) async{
    await FireDB().updateNoteFirestore(note);
    final db = await instance.database;

    await db!.update(NotesImpNames.TableName, {NotesImpNames.pin : !note.pin ? 1 : 0}, where:  '${NotesImpNames.id} = ?' ,whereArgs: [note.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future archNote(Note note) async{
    await FireDB().updateNoteFirestore(note);
    final db = await instance.database;

    await db!.update(NotesImpNames.TableName, {NotesImpNames.isArchive : !note.isArchive ? 1 : 0}, where:  '${NotesImpNames.id} = ?' ,whereArgs: [note.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future delteNote(Note note) async{
    await FireDB().deleteNoteFirestore(note);
    final db = await instance.database;

    await db!.delete(NotesImpNames.TableName, where: '${NotesImpNames.id}= ?', whereArgs: [note.id]);
  }

  Future closeDB() async{
    final db = await instance.database;
    db!.close();
  }

}