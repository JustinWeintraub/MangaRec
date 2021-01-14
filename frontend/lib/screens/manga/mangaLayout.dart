import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/middleware/mangaware.dart';
import 'package:frontend/middleware/userware.dart';
import 'package:frontend/shared/genres.dart';
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
  bool ignored = false;
  Map<String, dynamic> manga;
  MangaLayoutState(_manga) {
    manga = _manga;
  }

  main() async {
    try {
      String jwt = UserInheritedWidget.of(context).user['jwt'];
      manga["cover"] = await Mangaware().getCover(jwt, manga["id"]);
      dynamic userInfo = (await Userware().getManga(jwt));
      updateStatus(userInfo);
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  updateStatus(userInfo) {
    if (userInfo['manga'].contains(manga['title'])) {
      setState(() {
        favorited = true;
        ignored = false;
      });
    } else if (userInfo['ignoredManga'].contains(manga['title'])) {
      setState(() {
        favorited = false;
        ignored = true;
      });
    } else {
      setState(() {
        favorited = false;
        ignored = false;
      });
    }
  }

  updateFavorited() async {
    // manga can be favorited, meaning a user likes the manga
    dynamic res = await Userware()
        .favoriteManga(UserInheritedWidget.of(context).user['jwt'], manga);
    print(res);
    updateStatus(res);
  }

  updateIgnored() async {
    // manga can be favorited, meaning a user likes the manga
    dynamic res = await Userware()
        .ignoreManga(UserInheritedWidget.of(context).user['jwt'], manga);
    updateStatus(res);
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      main();
      return LoadingWidget();
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
                  onPressed: () => updateFavorited()),
              IconButton(
                  icon: Icon(ignored ? Icons.cancel : Icons.cancel_outlined,
                      color: Colors.black),
                  onPressed: () => updateIgnored()),
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
                alignment: WrapAlignment.center,
                children: manga['genres']
                    .map<Widget>((item) =>
                        new Text(genreConversion[int.parse(item)] + " "))
                    .toList()),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Icon(Icons.create),
              Wrap(
                  children: manga['authors']
                      .map<Widget>((item) => new Text(item + ". "))
                      .toList())
            ])
          ]));
  }
}
