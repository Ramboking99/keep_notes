import 'package:flutter/material.dart';
import 'package:keep_notes/colors.dart';
import 'package:keep_notes/services/db.dart';
import 'package:keep_notes/ui/ColorPalette.dart';
import 'package:uuid/uuid.dart';
import 'home.dart';
import 'model/MyNoteModel.dart';

class CreateNoteView extends StatefulWidget {
  const CreateNoteView({ Key? key }) : super(key: key);

  @override
  _CreateNoteViewState createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends State<CreateNoteView> {
  TextEditingController title = new TextEditingController();
  TextEditingController content = new TextEditingController();
  String noteColor = 'bgColor';
  var uuid = Uuid();

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
  void dispose() {
    super.dispose();
    title.dispose();
    content.dispose();
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
              onPressed: () async{
                await NotesDatabse.instance.insertEntry(Note(title : title.text , uniqueID: uuid.v1(), content : content.text , pin : false, createdTime: DateTime.now(), isArchive: false, noteColor: noteColor));
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
              },
              icon: Icon(Icons.save_outlined))
        ],
      ),

      body:
      Container(
        margin : EdgeInsets.symmetric(horizontal : 15 ,vertical: 10),
        child: Column(
          children: [
            TextField(
              cursorColor: white,
              controller: title,
              style: TextStyle(fontSize: 25, color: Colors.white , fontWeight: FontWeight.bold),
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
            Container(
              height: 300,
              child: TextField(
                cursorColor: white,
                controller: content,
                keyboardType:  TextInputType.multiline,
                minLines: 50,
                maxLines: null,
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
            )

          ],
        ),),

    );
  }


}