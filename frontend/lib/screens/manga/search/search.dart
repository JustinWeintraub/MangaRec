import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/screens/manga/search/genreSearch.dart';
import 'package:frontend/shared/bottomBar.dart';
import 'package:frontend/shared/genres.dart';

class Search extends StatefulWidget {
  List<dynamic> _allManga;
  Function _callback;

  bool isSelected = false;
  Search(allManga, callback) {
    _allManga = allManga;
    _callback = callback;
  }
  @override
  _SearchState createState() => _SearchState(_allManga, _callback);
}

class _SearchState extends State<Search> {
  List<dynamic> _allManga;
  Function _callback;
  Map<String, bool> _genreStates = getGenreStates();
  bool _displayManga = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _searchQueryController = TextEditingController();

  _SearchState(allManga, callback) {
    _allManga = allManga;
    _callback = callback;
  }

  void onGenreChange(name, value) {
    _genreStates[name] =
        value; // TODO would this work? is set state not necessary
  }

  void onGenreSubmit([genreStates]) {
    // _searchQueryController.text = newQuery;
    if (mounted)
      setState(() {
        if (genreStates != null) _genreStates = genreStates;
        _displayManga = !_displayManga;
      });
  }

  void onSearchSubmit() {
    List<dynamic> currentManga = new List();
    for (Map manga in _allManga) {
      // checking to see if potential mangas match search parameters
      // TODO do in backend?
      if (manga['title'].contains(_searchQueryController.text)) {
        for (String genre in manga['genres']) {
          if (_genreStates[genreConversion[int.parse(genre)]] == true) {
            currentManga.add(manga);
            break;
          }
        }
      }
    }
    if (currentManga.length == 0) // needs to be some mangas in search result
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        content: new Text('Invalid search.'),
        duration: new Duration(seconds: 5),
      ));
    else
      _callback(currentManga); // return result
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_displayManga)
      body = GenreSearch(_genreStates, onGenreSubmit);
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
                controller: _searchQueryController,
                decoration: InputDecoration(
                  hintText: "Search Keyword...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black12),
                ),
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                textAlign: TextAlign.center,
              )),
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
        key: _scaffoldKey);
  }
}
