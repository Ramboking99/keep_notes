import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keep_notes/model/MyNoteModel.dart';
import 'package:keep_notes/services/login_info.dart';
import 'db.dart';
class FireDB{
  //CREATE,READ,UPDATE,DELETE
  final FirebaseAuth _auth  = FirebaseAuth.instance;

  createNewNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if(isSyncOn.toString() == "true") {
        final User? currentUser =  _auth.currentUser;
        await FirebaseFirestore.instance.collection("notes").doc(currentUser!.email).collection("usernotes").doc(note.uniqueID).set(
            {
              "title" : note.title,
              "content" : note.content,
              "uniqueID" : note.uniqueID,
              "date" : note.createdTime,
              "noteColor" : note.noteColor,
              "pin" : note.pin,
              "isArchive" : note.isArchive
            }).then((_){
          print("DATA ADDED SUCCESSFULLY");
        });
      }
    });





  }




  getAllStoredNotes() async{
    final User? currentUser =  _auth.currentUser;
    await FirebaseFirestore.instance.collection("notes").doc(currentUser!.email).collection("usernotes").where("isArchive", isEqualTo: false).orderBy("pin", descending: true).orderBy("date", descending: true).get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        Map note = result.data();

        NotesDatabse.instance.insertEntry(Note(title:note["title"] , uniqueID:note["uniqueID"], content : note["content"] , createdTime: (note["date"] as Timestamp).toDate() , pin: note["pin"] ? true : false, isArchive: note["isArchive"] ? true : false, noteColor: note["noteColor"] ?? "bgColor"));  //Add Notes In Database
      }
    });

  }


  updateNoteFirestore(Note note) async{
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if(isSyncOn.toString() == "true") {
        final User? currentUser =  _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(currentUser!.email).collection("usernotes").doc(note.uniqueID)
            .update({"title": note.title , "content" : note.content, "noteColor" : note.noteColor, "pin" : note.pin, "isArchive" : note.isArchive}).then((_) {
          print("DATA UPDATED SUCCESFULLY");
        });
      }
    });


  }



  deleteNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if(isSyncOn.toString() == "true") {
        final User? currentUser =  _auth.currentUser;
        await FirebaseFirestore.instance.collection("notes").doc(currentUser!.email.toString()).collection("usernotes").doc(note.uniqueID).delete().then((_) {
          print("DATA DELETED SUCCESSFULLY");
        });
      }
    });


  }
}