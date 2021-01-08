import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/middleware/mangaware.dart';
import 'package:frontend/middleware/userware.dart';
import 'package:frontend/screens/manga/mangaLayout.dart';
import 'package:frontend/shared/bottomBar.dart';
import 'package:frontend/shared/listWrapper.dart';
import 'package:frontend/shared/loading/loadingPage.dart';

// TODO detach from manga
// wraps a list of objects allowing the user to easily navigate between said objects
class MangaViewer extends StatefulWidget {
  List _mangaSelected;

  MangaViewer(mangaSelected) {
    _mangaSelected = mangaSelected;
  }
  @override
  _MangaViewerState createState() => new _MangaViewerState();
}

class _MangaViewerState extends State<MangaViewer> {
  bool loading = true;
  int _cutIndex = 0;
  ScrollController _scrollController = new ScrollController();
  List userManga; //TODO update underscores
  List _mangaCut = [];

  MangaLayout createChild(manga) {
    bool favorited = false;
    if (userManga.contains(manga['title'])) favorited = true;
    //TODO add onClick
    return MangaLayout(manga, favorited);
  }

  main() async {
    setState(() {
      loading = true;
    });

    double currentPos; // setting up scroll bar position to beginning
    if (_scrollController.hasClients)
      currentPos = _scrollController.position.maxScrollExtent;

    List mangaSelected = widget
        ._mangaSelected; // segmenting current manga to limit database calls
    List mangaCut = _mangaCut;
    for (int i = _cutIndex;
        i <
            (_cutIndex + 5 > mangaSelected.length
                ? mangaSelected.length
                : _cutIndex + 5);
        i++) {
      mangaCut.add(mangaSelected[i]);
      mangaCut[i]["cover"] = await Mangaware().getCover(
          UserInheritedWidget.of(context).user['jwt'], mangaCut[i]["id"]);
    }
    _cutIndex += 5;

    dynamic _userManga = (await Userware()
        .getManga(UserInheritedWidget.of(context).user['jwt']))['manga'];
    setState(() {
      userManga = _userManga;
      loading = false;
    });
    if (currentPos != null)
      _scrollController = ScrollController(initialScrollOffset: currentPos);
  }

  @override
  Widget build(BuildContext context) {
    if (_mangaCut.length == 0 && widget._mangaSelected.length != 0) {
      _cutIndex = 0;
      main();
    }
    if (loading == true) return Loading();
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: const Text('Manga List'),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.arrow_circle_up),
              onPressed: () {
                _scrollController.animateTo(
                  0.0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              }),
          IconButton(
              icon: new Icon(Icons.arrow_circle_down),
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              }),
        ],
      ),
      body: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(vertical: 100.0),
          child: Column(children: [
            Wrap(children: listWrapper(_mangaCut, createChild).cast<Widget>()),
            SizedBox(height: 20.0),
            if (_mangaCut.length != widget._mangaSelected.length)
              TextButton(onPressed: main, child: Text("Show more"))
          ])),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
