import 'package:flutter/material.dart';
import 'package:keep_notes/colors.dart';
import 'package:keep_notes/services/login_info.dart';

class Settings extends StatefulWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool value = true;

  getSyncSet() async {
    LocalDataSaver.getSyncSet().then((valueFromDB) {
      setState(() {
        value = valueFromDB!;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getSyncSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(backgroundColor: bgColor,
          elevation: 0.0,
          title : const Text("Settings")
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            const Text("Sync" ,style: TextStyle(color: Colors.white , fontSize: 18),),
            const Spacer(),
            Transform.scale(scale: 1.3,
              child : Switch.adaptive(value: value, onChanged: (switchValue) {
                setState(() {
                  value = switchValue;
                  LocalDataSaver.saveSyncSet(switchValue);
                });
              }),)
          ],)
        ],),),
    );
  }
}