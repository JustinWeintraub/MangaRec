import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/middleware/mangaware.dart';
import 'package:frontend/middleware/userware.dart';
import 'package:frontend/screens/manga/mangaLayout.dart';
import 'package:frontend/screens/manga/mangaWrapper.dart';
import 'package:frontend/shared/bottomBar.dart';
import 'package:frontend/shared/functions.dart';
import 'package:frontend/shared/listWrapper.dart';
import 'package:frontend/shared/loading/loadingPage.dart';
import 'package:frontend/widgets/scrollableListViewer.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<dynamic> manga;
  List<dynamic> ignoredManga;
  Widget nextChild;

  goToManga(title, jwt) async {
    dynamic request = await Mangaware().getManga(jwt, title);
    if (request["success"] && mounted)
      setState(() {
        nextChild = ScrollableListViewer(
            [request["manga"]], "User's Manga", (manga) => MangaLayout(manga));
      });
  }

  main() async {
    String jwt = UserInheritedWidget.of(context).user['jwt'];
    dynamic request = await Userware().getManga(jwt);
    if (request["success"] == true && mounted) {
      setState(() {
        manga = request["manga"];
        ignoredManga = request["ignoredManga"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    addManga() {
      if (mounted)
        setState(() {
          nextChild = MangaWrapper();
        });
    }

    Widget createChild(title, jwt) {
      return TextButton(
          onPressed: () {
            goToManga(title, jwt);
          },
          child: Text(title));
    }

    String jwt = UserInheritedWidget.of(context).user['jwt'];
    dynamic userData = parseJwt(jwt);
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
                  children: listWrapper(manga, (data) => createChild(data, jwt))
                      .cast<Widget>(),
                )),
            Text("Ignored Manga", style: TextStyle(fontSize: 30.0)),
            SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listWrapper(
                          ignoredManga, (data) => createChild(data, jwt))
                      .cast<Widget>(),
                )),
          ])),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
