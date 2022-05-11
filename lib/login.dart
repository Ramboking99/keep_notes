import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:keep_notes/colors.dart';
import 'package:keep_notes/services/auth.dart';
import 'package:keep_notes/services/firestore_db.dart';
import 'package:keep_notes/services/login_info.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> goToHome(context) async {
    await signInWithGoogle();
    final User? currentUser = await _auth.currentUser;
    LocalDataSaver.saveLoginData(true);
    LocalDataSaver.saveImg(currentUser!.photoURL.toString());
    LocalDataSaver.saveMail(currentUser.email.toString());
    LocalDataSaver.saveName(currentUser.displayName.toString());
    LocalDataSaver.saveSyncSet(true);
    await FireDB().getAllStoredNotes();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
  }

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350, height: MediaQuery.of(context).size.height/1.9,));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFFFE600),
    //activeColor: Colors.orange,
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
    bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white),
    contentMargin: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(24),
    pageColor: bgColor,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Create beautiful notes',
          body: 'Start saving your notes digitally available across all devices',
          image: buildImage('assets/images/createNotes.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Simple UI with Colourful Notes',
          body: 'Create Colorful Notes and pin them to top',
          image: buildImage('assets/images/colorNotes.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Archive Notes',
          body: 'Archive your personal notes to the Archived folder',
          image: buildImage('assets/images/archiveNotes.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Sign In',
          body: 'Sync your notes and access them through your Google Account',
          footer: SignInButton(Buttons.Google, onPressed:() async {
            await signInWithGoogle();
            final User? currentUser = await _auth.currentUser;
            LocalDataSaver.saveLoginData(true);
            LocalDataSaver.saveImg(currentUser!.photoURL.toString());
            LocalDataSaver.saveMail(currentUser.email.toString());
            LocalDataSaver.saveName(currentUser.displayName.toString());
            LocalDataSaver.saveSyncSet(true);
            await FireDB().getAllStoredNotes();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
          }),
          image: buildImage('assets/images/cloudSync.png'),
          decoration: getPageDecoration(),
        ),
      ],
      done: Text('Sign In', style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: Text('Skip'),
      onSkip: () => goToHome(context),
      next: Icon(Icons.arrow_forward),
      dotsDecorator: getDotDecoration(),
      onChange: (index) => print('Page $index selected'),
      globalBackgroundColor: bgColor,
      dotsFlex: 0,
      nextFlex: 0,
      // isProgressTap: false,
      // isProgress: false,
      // showNextButton: false,
      // freeze: true,
      // animationDuration: 1000,
    ),
    );
  }
}




// Scaffold(
// appBar: AppBar(title: Text("Login To App"),),
// body: Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// SignInButton(Buttons.Google, onPressed:() async {
// await signInWithGoogle();
// final User? currentUser = await _auth.currentUser;
// LocalDataSaver.saveLoginData(true);
// LocalDataSaver.saveImg(currentUser!.photoURL.toString());
// LocalDataSaver.saveMail(currentUser.email.toString());
// LocalDataSaver.saveName(currentUser.displayName.toString());
// LocalDataSaver.saveSyncSet(true);
// await FireDB().getAllStoredNotes();
// Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
// }),
// ],
// ),
// ),
// );