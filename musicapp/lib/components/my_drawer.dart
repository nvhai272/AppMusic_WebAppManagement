import 'package:flutter/material.dart';

import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
              child: Center(
                  child: Icon(
            Icons.music_note,
            size: 40,
            color: Theme.of(context).colorScheme.inversePrimary,
          ))),
          Padding(
            padding: EdgeInsets.only(left: 25.0, top: 25),
            child: ListTile(
                title: Text("H O M E"),
                leading: Icon(Icons.home),
                onTap: () {}),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, top: 25),
            child: ListTile(
                title: Text("S E T T I N G"),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingPage(),
                      ));
                }),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 25.0, top: 10),
          //   child: ListTile(
          //       title: Text("S E T T I N G"),
          //       leading: Icon(Icons.settings),
          //       onTap: () {}),
          // ),
        ],
      ),
    );
  }
}
