import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/middleware/mangaware.dart';
import 'package:frontend/middleware/userware.dart';
import 'package:frontend/screens/manga/mangaViewer.dart';
import 'package:frontend/screens/manga/mangaWrapper.dart';
import 'package:frontend/shared/bottomBar.dart';
import 'package:frontend/shared/functions.dart';
import 'package:frontend/shared/listWrapper.dart';
import 'package:frontend/shared/loading.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<dynamic> manga;
  Widget nextChild;

  main() async {
    String jwt = UserInheritedWidget.of(context).user['jwt'];
    dynamic request = await Userware().getManga(jwt);
    //TODO if error realize it
    if (request["success"] == false) return;
    for (int i = 0; i < request["manga"].length; i++) {
      dynamic mangaRequest =
          await Mangaware().getManga(jwt, request["manga"][i]);
      request["manga"][i] = mangaRequest["manga"];
      if (mangaRequest["success"] == false) return;
      //TODO errors in not working
    }
    if (request["success"] == true) {
      setState(() {
        manga = request["manga"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    addManga() {
      setState(() {
        nextChild = MangaWrapper();
      });
    }

    Widget createChild(manga) {
      return TextButton(
          onPressed: () {
            setState(() {
              nextChild = MangaViewer([manga]);
            });
          },
          child: Text(manga['title']));
    }

    dynamic userData = parseJwt(UserInheritedWidget.of(context).user['jwt']);
    if (manga == null) {
      main();
      return Loading();
    }
    if (nextChild != null) return nextChild;
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(userData['username'], style: TextStyle(fontSize: 40.0)),
            Divider(height: 20, thickness: 2, color: Colors.black54),
            SizedBox(height: 20.0),
            Row(children: <Widget>[
              Text("Liked Manga", style: TextStyle(fontSize: 30.0)),
              SizedBox(width: 10.0),
              IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  onPressed: () => addManga())
            ]),
            SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listWrapper(manga, createChild).cast<Widget>(),
                ))
          ])),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
