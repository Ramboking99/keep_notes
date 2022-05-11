import 'package:flutter/material.dart';
import 'package:keep_notes/NoteView.dart';
import 'package:keep_notes/colors.dart';
import 'package:keep_notes/services/db.dart';
import 'package:keep_notes/ui/ColorPalette.dart';
import 'model/MyNoteModel.dart';

class EditNoteView extends StatefulWidget {
  Note note;
  EditNoteView({ Key? key, required this.note}) : super(key: key);

  @override
  _EditNoteViewState createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  late String newTitle;
  late String newNoteContent;
  late String noteColor;

  void handleColor(BuildContext currentContext) {
    showDialog(
      context: currentContext,
      builder: (context) => ColorPalette(
        parentContext: currentContext,
      ),
    ).then((colorName) {
      if (colorName != null) {
        setState(() {
          noteColor = colorName;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    newTitle = widget.note.title.toString();
    newNoteContent = widget.note.content.toString();
    noteColor = widget.note.noteColor.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(NoteColors[noteColor]!['l'] ?? 0xFF212227),
      appBar: AppBar(
        backgroundColor: Color(NoteColors[noteColor]!['b'] ?? 0xFF212227),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.color_lens,
              color: white,
            ),
            tooltip: 'Color Palette',
            onPressed: () => handleColor(context),
          ),
          IconButton(
              splashRadius: 17,
              onPressed: () async {
                Note newNote = Note(uniqueID: widget.note.uniqueID, pin: widget.note.pin, title: newTitle, content: newNoteContent, createdTime: widget.note.createdTime, id: widget.note.id, isArchive: widget.note.isArchive, noteColor: noteColor);
                await NotesDatabse.instance.updateNote(newNote);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoteView(note: newNote)));
              },
              icon: const Icon(Icons.save_outlined))
        ],
      ),

      body:
      Container(
        margin : const EdgeInsets.symmetric(horizontal : 15 ,vertical: 10),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                initialValue: newTitle,
                cursorColor: white,
                onChanged: (value) {
                  newTitle = value;
                },
                style: const TextStyle(fontSize: 25, color: Colors.white , fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.8))),
              ),
            ),

            SizedBox(
              height: 300,
              child: Form(
                child: TextFormField(
                  initialValue: newNoteContent,
                  cursorColor: white,
                  keyboardType:  TextInputType.multiline,
                  minLines: 50,
                  maxLines: null,
                  onChanged: (value) {
                    newNoteContent = value;
                  },
                  style: TextStyle(fontSize: 17, color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Note",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.withOpacity(0.8))),
                ),
              ),
            )

          ],
        ),),

    );
  }
}