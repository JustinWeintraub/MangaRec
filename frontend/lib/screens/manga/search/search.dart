import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/middleware/mangaware.dart';
import 'package:frontend/screens/manga/mangaLayout.dart';
import 'package:frontend/screens/manga/search/genreSearch.dart';
import 'package:frontend/shared/bottomBar.dart';
import 'package:frontend/shared/contexedRoute.dart';
import 'package:frontend/shared/genres.dart';
import 'package:frontend/widgets/scrollableListViewer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Search extends StatefulWidget {
  bool isSelected = false;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Map<String, bool> genreStates = getGenreStates();
  bool displayManga = false;
  String sortValue = 'views DESC';
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchQueryController = TextEditingController();

  _SearchState();

  void onGenreChange(name, value) {
    genreStates[name] =
        value; // TODO would this work? is set state not necessary
  }

  void onGenreSubmit([_genreStates]) {
    // searchQueryController.text = newQuery;
    if (mounted)
      setState(() {
        if (_genreStates != null) genreStates = genreStates;
        displayManga = !displayManga;
      });
  }

  void generateScafoldKey(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.red[400],
      content: new Text(text),
      duration: new Duration(seconds: 5),
    ));
  }

  void onSearchSubmit() async {
    List<String> sortSplit = sortValue.split(" ");

    List<int> genreCodes = [];
    for (String genre in genreStates.keys) {
      if (genreStates[genre] == true)
        genreCodes.add(genreCodeConversion[genre]);
    }
    Map<String, dynamic> request = await Mangaware().getAll(
        UserInheritedWidget.of(context).user['jwt'],
        searchQueryController.text,
        genreCodes,
        sortSplit[0],
        sortSplit[1]);
    if (!request["success"]) {
      generateScafoldKey('Something broke.');
      return;
    }

    if (request["manga"].length ==
        0) // needs to be some mangas in search result
      generateScafoldKey('Invalid search.');
    else {
      Navigator.push(
          context,
          contexedRoute(
              context,
              ScrollableListViewer(request["manga"], "Manga List",
                  (manga) => MangaLayout(manga))));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (displayManga)
      body = GenreSearch(genreStates, onGenreSubmit);
    else {
      body = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          RaisedButton(
            child: Text("Choose Genres"),
            onPressed: onGenreSubmit,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
              width: 300.0,
              child: TextField(
                controller: searchQueryController,
                decoration: InputDecoration(
                  hintText: "Search Keyword...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black12),
                ),
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                textAlign: TextAlign.center,
              )),
          SizedBox(height: 20.0),
          DropdownButton<String>(
              value: sortValue,
              icon: Icon(Icons.arrow_drop_down),
              onChanged: (String newValue) {
                if (mounted)
                  setState(() {
                    sortValue = newValue;
                  });
              },
              items: [
                DropdownMenuItem<String>(
                  value: "views DESC",
                  child: Row(children: [
                    Text("Views"),
                    Icon(MdiIcons.fromString('sort-numeric-descending'))
                  ]),
                ),
                DropdownMenuItem<String>(
                  value: "views ASC",
                  child: Row(children: [
                    Text("Views"),
                    Icon(MdiIcons.fromString('sort-numeric-ascending'))
                  ]),
                ),
                DropdownMenuItem<String>(
                  value: "title ASC",
                  child: Row(children: [
                    Text("Title"),
                    Icon(MdiIcons.fromString('sort-alphabetical-ascending'))
                  ]),
                ),
                DropdownMenuItem<String>(
                  value: "title DESC",
                  child: Row(children: [
                    Text("Title"),
                    Icon(MdiIcons.fromString('sort-alphabetical-descending'))
                  ]),
                ),
              ]),
          SizedBox(height: 20.0),
          RaisedButton(
              child: Text("Submit"),
              onPressed: onSearchSubmit,
              color: Colors.blue[400])
        ])
      ]);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        backgroundColor: Colors.orange[100],
        body: body,
        bottomNavigationBar: bottomBar(context),
        key: scaffoldKey);
  }
}
