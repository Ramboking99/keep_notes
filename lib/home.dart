import 'package:flutter/services.dart';
import 'package:keep_notes/login.dart';
import 'package:keep_notes/services/auth.dart';
import 'package:keep_notes/services/db.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keep_notes/services/login_info.dart';
import 'SearchPage.dart';
import 'package:keep_notes/CreateNoteView.dart';
import 'NoteView.dart';
import 'CreateNoteView.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:keep_notes/SideMenuBar.dart';
import 'package:keep_notes/colors.dart';

import 'model/MyNoteModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isLoading = true;
  bool isStaggerred = true;
  late String? imgUrl;
  late List<Note> notesList;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String note =
      "THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE";
  String note1 = "THIS IS NOTE THIS IS NOTE THIS IS NOTE";
  @override
  void initState() {
    super.initState();
    //LocalDataSaver.saveSyncSet(true);
    //createEntry(Note(pin: false, title: "Welcome to Keep Notes", content: "This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. This is my content. I am coding. ", createdTime: DateTime.now(), isArchive: false, uniqueID: 'MHVCSDJHVICUGEILDUGCWEIUCFGWE'));
    //createEntry();
    //deleteNote();
    //delteDB();
    getAllNotes();
    //updateOneNote();
    //getOneNote();
  }

  Future delteDB () async {
    final db = await NotesDatabse.instance.database;
    await db?.delete(NotesImpNames.TableName);
  }

  Future createEntry(Note note) async{
    await NotesDatabse.instance.insertEntry(note);
  }

  Future getAllNotes() async{
    LocalDataSaver.getImg().then((value){
      if(mounted){
        setState(() {
          imgUrl = value;
        });
      }
    });

    notesList = await NotesDatabse.instance.readAllNotes();
    if(mounted){
      setState(() {

        isLoading = false;
      });
    }
  }
  Future getOneNote(int id) async{
    await NotesDatabse.instance.readOneNote(id);
  }

  Future updateOneNote(Note note) async{
    await NotesDatabse.instance.updateNote(note);

  }

  Future deleteNote(Note note) async{
    await NotesDatabse.instance.delteNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
      return false;
    },
    child: isLoading ? Scaffold( backgroundColor: bgColor,  body: Center(child: CircularProgressIndicator(color: goldenYellow,),),) : Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => const CreateNoteView()) );
          },
          backgroundColor: cardColor,
          child: const Icon(Icons.add , size: 45,),
        ),
        endDrawerEnableOpenDragGesture: true,
        key: _drawerKey,
        drawer: const SideMenu(),
        backgroundColor: bgColor,
        body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 2));
                getAllNotes();
              },
              color: goldenYellow,
              displacement: 70,
              backgroundColor: Colors.black,
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 55,
                          decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3)
                              ]),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _drawerKey.currentState!.openDrawer();
                                        },
                                        splashRadius: 17,
                                        icon: const Icon(
                                          Icons.menu,
                                          color: white,
                                        )),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    GestureDetector(
                                      onTap: ()
                                      {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchView()));
                                      },
                                      child:  SizedBox(
                                          height: 55,
                                          width: MediaQuery.of(context).size.width/1.9,
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Search Your Notes",
                                                  style: TextStyle(
                                                      color: white.withOpacity(0.5),
                                                      fontSize: 16),
                                                )
                                              ])),
                                    ),
                                    TextButton(
                                        style: ButtonStyle(
                                            overlayColor:
                                            MaterialStateColor.resolveWith(
                                                    (states) =>
                                                    white.withOpacity(0.1)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(50.0),
                                                ))),
                                        onPressed: () {
                                          setState(() {
                                            isStaggerred = !isStaggerred;
                                          });
                                        },
                                        child: isStaggerred == true ?
                                            Icon(Icons.list_alt_outlined, color: white,) : Icon(
                                           Icons.grid_view,
                                          color: white,
                                        )
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        signOut();
                                        LocalDataSaver.saveLoginData(false);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                                      },
                                      child: CircleAvatar(
                                        onBackgroundImageError: (Object, StackTrace){
                                          print("Ok");
                                        },
                                        radius: 16,
                                        backgroundImage: NetworkImage(imgUrl.toString()),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ])),
                      isStaggerred ? NoteSectionAll() : NotesListSection()
                    ],
                  ),
                ),
              ),
            ))));
  }

  Widget NoteSectionAll() {
    return Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "ALL",
                    style: TextStyle(
                        color: white.withOpacity(0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: StaggeredGridView.countBuilder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        //BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        shrinkWrap: true,
                        itemCount: notesList.length,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        crossAxisCount: 4,
                        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
                        itemBuilder: (context, index) =>
                            InkWell(
                              onTap: ()
                              {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NoteView(note: notesList[index],)));
                              },
                              child:
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: notesList[index].noteColor == "bgColor" ? cardColor : Color(NoteColors[notesList[index].noteColor]!['b'] ?? 0xFF2D2E33),
                                    border: Border.all(color: notesList[index].noteColor == "bgColor" ? white.withOpacity(0.4) : Color(NoteColors[notesList[index].noteColor]!['b'] ?? 0xFFFFFFFF)),
                                    borderRadius: BorderRadius.circular(7)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notesList[index].title,
                                        style: const TextStyle(
                                            color: white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(notesList[index].content.length > 250
                                        ? "${notesList[index].content.substring(0, 250)}..."
                                        : notesList[index].content,

                                      style: const TextStyle(color: white),
                                    )
                                  ],
                                ),
                              ),

                            )
                  ),

            ),
          ],
        ));
  }

  Widget NotesListSection() {
    return Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "ALL",
                    style: TextStyle(
                        color: white.withOpacity(0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          //BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          itemCount: notesList.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NoteView(note: notesList[index],)));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: notesList[index].noteColor == "bgColor" ? cardColor : Color(NoteColors[notesList[index].noteColor]!['b'] ?? 0xFF2D2E33),
                                  border: Border.all(color: notesList[index].noteColor == "bgColor" ? white.withOpacity(0.4) : Color(NoteColors[notesList[index].noteColor]!['b'] ?? 0xFFFFFFFF)),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notesList[index].title,
                                      style: const TextStyle(
                                          color: white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(notesList[index].content.length > 250
                                      ? "${notesList[index].content.substring(0, 250)}..."
                                      : notesList[index].content,

                                    style: const TextStyle(color: white),
                                  )
                                ],
                              ),
                            ),
                          ),
                      ),

            ),
          ],
        ));
  }
}