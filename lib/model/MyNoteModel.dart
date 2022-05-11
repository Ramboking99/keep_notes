class NotesImpNames{
  static final String id = "id";
  static final String uniqueID = "uniqueID";
  static final String pin = "pin";
  static final String title = "title";
  static final String isArchive = "isArchive";
  static final String content = "content";
  static final String createdTime = "createdTime";
  static final String TableName = "Notes";
  static final String noteColor = "noteColor";
  static final List<String> values = [id, uniqueID, isArchive, pin, title, content, createdTime, noteColor];
}


class Note{
  final int? id;
  final String uniqueID;
  final bool pin;
  final bool isArchive;
  final String title;
  final String noteColor;
  final String content;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.uniqueID,
    required this.pin,
    required this.isArchive,
    required this.title,
    required this.content,
    this.noteColor = 'bgColor',
    required this.createdTime,
  });

  Note copy({
    int? id,
    String? uniqueID,
    bool? pin,
    bool? isArchive,
    String? title,
    String? content,
    String? noteColor,
    DateTime? createdTime,
  }) {
    return Note(id : id?? this.id ,
        uniqueID:  uniqueID ?? this.uniqueID,
        pin:pin ?? this.pin,
        isArchive:isArchive ?? this.isArchive,
        title:  title ?? this.title,
        content:  content ?? this.content,
        noteColor: noteColor ?? this.noteColor,
        createdTime:  createdTime ?? this.createdTime
    );
  }



  static Note fromJson(Map<String ,Object?> json){
    return Note(id: json[NotesImpNames.id] as int? ,
        uniqueID: json[NotesImpNames.uniqueID] as String,
        pin : json[NotesImpNames.pin] ==1,
        isArchive : json[NotesImpNames.isArchive] == 1,
        title: json[NotesImpNames.title] as String,
        content: json[NotesImpNames.content] as String,
        noteColor: json[NotesImpNames.noteColor] as String,
        createdTime: DateTime.parse(json[NotesImpNames.createdTime] as String)
    );
  }

  Map<String,Object?> toJson() {
    return {
      NotesImpNames.id : id,
      NotesImpNames.uniqueID : uniqueID,
      NotesImpNames.pin : pin ? 1 : 0,
      NotesImpNames.isArchive : isArchive ? 1 : 0,
      NotesImpNames.title : title,
      NotesImpNames.content : content,
      NotesImpNames.noteColor : noteColor,
      NotesImpNames.createdTime : createdTime.toIso8601String()
    };
  }
}

//  id INTEGER PRIMARY KEY AUTOINCREMENT,
//     pin BOOLEAN NOT NULL,
//     title TEXT NOT NULL,
//     content TEXT NOT NULL,
//     createdTime TEXT NOT NULL