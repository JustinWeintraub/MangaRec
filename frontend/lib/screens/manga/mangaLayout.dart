import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/middleware/mangaware.dart';
import 'package:frontend/middleware/userware.dart';
import 'package:frontend/shared/loading/loadingWidget.dart';

// displays the info on a manga in a user friendly format

class MangaLayout extends StatefulWidget {
  //final Function toggleView;
  //Wrapper({this.toggleView});
  Map<String, dynamic> manga;

  MangaLayout(
    _manga,
  ) {
    manga = _manga;
  }
  @override
  MangaLayoutState createState() => MangaLayoutState(manga);
}

class MangaLayoutState extends State<MangaLayout> {
  bool loading = true;
  bool favorited = false;
  Map<String, dynamic> manga;
  MangaLayoutState(_manga) {
    manga = _manga;
  }

  main() async {
    try {
      manga["cover"] = await Mangaware()
          .getCover(UserInheritedWidget.of(context).user['jwt'], manga["id"]);
      dynamic userManga = (await Userware()
          .getManga(UserInheritedWidget.of(context).user['jwt']))['manga'];
      if (userManga.contains(manga['title'])) favorited = true;

      setState(() {
        loading = false;
      });
    } catch (e) {}
  }

  updateFavorite() async {
    // manga can be favorited, meaning a user likes the manga
    dynamic res = await Userware().changeManga(
        UserInheritedWidget.of(context).user['jwt'], manga, favorited);
    if (res["success"] == true)
      setState(() {
        favorited = !favorited;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      main();
      return loadingWidget();
    } else
      return Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Row(children: [
              Expanded(
                  child: Text(
                manga['title'],
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 30.0,
                ),
              )),
              IconButton(
                  icon: Icon(favorited ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pink),
                  onPressed: () => updateFavorite()),
              SizedBox(width: 10.0),
            ]),
            Container(
                width: 300,
                height: 500,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: MemoryImage(manga['cover']),
                  fit: BoxFit.fitWidth,
                ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.person,
                ),
                Text(
                  manga['views'].toString(),
                  style: new TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            Wrap(
                children: manga['authors']
                    .map<Widget>((item) => new Text(item + ". "))
                    .toList()),
          ]));
  }
}
