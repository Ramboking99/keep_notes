import 'package:flutter/material.dart';
import 'package:keep_notes/ArchiveView.dart';
import 'package:intl/intl.dart';
import 'package:keep_notes/colors.dart';
import 'package:keep_notes/services/db.dart';
import 'EditNoteView.dart';
import 'home.dart';
import 'model/MyNoteModel.dart';
class NoteView extends StatefulWidget {
  Note note;
  NoteView({ Key? key, required this.note}) : super(key: key);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(NoteColors[widget.note.noteColor]!['l'] ?? 0xFF212227),
        appBar: AppBar(
          backgroundColor: Color(NoteColors[widget.note.noteColor]!['b'] ?? 0xFF212227),
          leading: IconButton(
              splashRadius: 17,
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
              },
              icon: Icon(Icons.arrow_back)),
          elevation: 0.0,
          actions: [
            IconButton(
                splashRadius: 17,
                onPressed: () async {
                  await NotesDatabse.instance.pinNote(widget.note);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                },
                icon: Icon(widget.note.pin == true ? Icons.push_pin :Icons.push_pin_outlined)),
            IconButton(
                splashRadius: 17,
                onPressed: () async{
                  await NotesDatabse.instance.archNote(widget.note);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                } ,
                icon: Icon(widget.note.isArchive ? Icons.archive : Icons.archive_outlined)),
            IconButton(
                splashRadius: 17,
                onPressed: () async{
                  await NotesDatabse.instance.delteNote(widget.note);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                },
                icon: Icon(Icons.delete_forever_outlined)),
            IconButton(
                splashRadius: 17,
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditNoteView(note: widget.note,)));
                },
                icon: const Icon(Icons.edit_outlined))
          ],
        ),

        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children : [
                  Text("Created on ${DateFormat('dd-MM-yyyy - kk:mm').format(widget.note.createdTime)}", style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.note.title , style: const TextStyle(color: Colors.white , fontSize: 26 , fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20,),
                  Text(widget.note.content,style: const TextStyle(color: Colors.white, fontSize: 16),)
                ]

            ),
          ),
        ),
      ),
    );
  }
}