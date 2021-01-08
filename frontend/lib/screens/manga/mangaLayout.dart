import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/middleware/userware.dart';

// displays the info on a manga in a user friendly format

class MangaLayout extends StatefulWidget {
  //final Function toggleView;
  //Wrapper({this.toggleView});
  Map<String, dynamic> manga;
  bool favorited;

  MangaLayout(_manga, _favorited) {
    manga = _manga;
    favorited = _favorited;
  }
  @override
  MangaLayoutState createState() => MangaLayoutState(manga);
}

class MangaLayoutState extends State<MangaLayout> {
  Map<String, dynamic> manga;
  MangaLayoutState(_manga) {
    manga = _manga;
  }

  updateFavorite() async {
    // manga can be favorited, meaning a user likes the manga
    await Userware().changeManga(
        UserInheritedWidget.of(context).user['jwt'], manga, widget.favorited);
    setState(() {
      widget.favorited = !widget.favorited;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                icon: Icon(
                    widget.favorited ? Icons.favorite : Icons.favorite_border,
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
