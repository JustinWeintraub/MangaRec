import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatefulWidget {
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  bool stuck = false;
  Widget spin = SpinKitChasingDots(color: Colors.brown, size: 50.0);

  _LoadingWidgetState();
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (mounted)
        setState(() {
          stuck = true;
        });
    });
    return Container(
        color: Colors.orange[100],
        child: Center(
            child: stuck
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        spin,
                        new Text(
                            "Stuck loading? Your session may've expired and you need to logout.",
                            textAlign: TextAlign.center)
                      ])
                : spin));
    //userInfo.updateChild(userInfo, MangaViewer(mangaSelected))
  }
}
