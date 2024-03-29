import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/middleware/mangaware.dart';
import 'package:frontend/middleware/userware.dart';
import 'package:frontend/screens/manga/mangaLayout.dart';
import 'package:frontend/shared/loading/loadingPage.dart';
import 'package:frontend/widgets/scrollableListViewer.dart';

//TODO need to be able to remove from recommended

class Recommend extends StatefulWidget {
  @override
  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  bool loading = true;
  List<dynamic> suggestedManga;
  //final Function toggleView;
  //Wrapper({this.toggleView});
  Widget nextChild;

  main() async {
    String jwt = UserInheritedWidget.of(context).user['jwt'];
    dynamic request = await Userware().suggestManga(jwt);
    if (request["success"] == false) return;
    for (int i = 0; i < request["manga"].length; i++) {
      dynamic mangaRequest =
          await Mangaware().getManga(jwt, request["manga"][i]);
      request["manga"][i] = mangaRequest["manga"];
      if (mangaRequest["success"] == false) return;
    }
    if (request["success"] == true && mounted) {
      setState(() {
        suggestedManga = request["manga"];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      main();
      return Loading();
    }
    if (nextChild != null) return nextChild; // TODO what is this for?
    return ScrollableListViewer(
        suggestedManga, "Suggested Manga", (manga) => MangaLayout(manga));
  }
}
