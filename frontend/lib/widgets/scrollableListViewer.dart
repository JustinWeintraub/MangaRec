import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/shared/bottomBar.dart';
import 'package:frontend/shared/listWrapper.dart';
import 'package:frontend/shared/loading/loadingPage.dart';

// TODO detach from object
// wraps a list of objects allowing the user to easily navigate between said objects
class ScrollableListViewer extends StatefulWidget {
  List objectsSelected;
  String title;
  Function child;

  ScrollableListViewer(_objectsSelected, _title, _child) {
    objectsSelected = _objectsSelected;
    title = _title;
    child = _child;
  }
  @override
  _ScrollableListViewerState createState() => new _ScrollableListViewerState();
}

class _ScrollableListViewerState extends State<ScrollableListViewer> {
  bool loading = true;
  int _cutIndex = 0;
  ScrollController _scrollController = new ScrollController();
  List userobject; //TODO update underscores
  List _objectsCut = [];

  Widget createChild(object) {
    //TODO add onClick
    return widget.child(object);
  }

  main() {
    setState(() {
      loading = true;
    });

    double currentPos; // setting up scroll bar position to beginning
    if (_scrollController.hasClients)
      currentPos = _scrollController.position.maxScrollExtent;

    List objectsSelected = widget
        .objectsSelected; // segmenting current object to limit database calls
    List objectsCut = _objectsCut;
    for (int i = _cutIndex;
        i <
            (_cutIndex + 5 > objectsSelected.length
                ? objectsSelected.length
                : _cutIndex + 5);
        i++) {
      objectsCut.add(objectsSelected[i]);
    }
    _cutIndex += 5;

    setState(() {
      loading = false;
    });
    if (currentPos != null)
      _scrollController = ScrollController(initialScrollOffset: currentPos);
  }

  @override
  Widget build(BuildContext context) {
    if (_objectsCut.length == 0 && widget.objectsSelected.length != 0) {
      _cutIndex = 0;
      main();
    }
    if (loading == true) return Loading();
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text(widget.title), // TODO pass in title
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
            Wrap(
                children: listWrapper(_objectsCut, createChild).cast<Widget>()),
            SizedBox(height: 20.0),
            if (_objectsCut.length != widget.objectsSelected.length)
              TextButton(onPressed: main, child: Text("Show more"))
          ])),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
