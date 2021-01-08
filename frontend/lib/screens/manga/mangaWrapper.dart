import 'package:flutter/material.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/middleware/mangaware.dart';
import 'package:frontend/screens/manga/mangaViewer.dart';
import 'package:frontend/screens/manga/search/search.dart';
import 'package:frontend/shared/loading.dart';
import 'package:frontend/shared/contexedRoute.dart';

// USAGE: wraps the search functionality, getting all the manga initially to be searched from
// displaying pages based off of whether or not data is gotten or search is complete

class MangaWrapper extends StatefulWidget {
  @override
  _MangaWrapperState createState() => _MangaWrapperState();
}

class _MangaWrapperState extends State<MangaWrapper> {
  List<dynamic> mangaData;
  bool loading = true;
  dynamic child = Loading();
  void main() async {
    Map<String, dynamic> data =
        await Mangaware().getAll(UserInheritedWidget.of(context).user['jwt']);
    if (data["success"]) {
      setState(() {
        loading = false;
        child = Search(data["manga"], searchComplete);
        mangaData = data["manga"];
      });
    }
  }

  void searchComplete(List mangaSelected) {
    Navigator.push(context, contexedRoute(context, MangaViewer(mangaSelected)));
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) main();

    return Scaffold(backgroundColor: Colors.orange[100], body: child);
  }
}
