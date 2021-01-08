import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingWidget() {
  return Container(
      color: Colors.orange[100],
      child:
          Center(child: SpinKitChasingDots(color: Colors.brown, size: 50.0)));
  //userInfo.updateChild(userInfo, MangaViewer(mangaSelected))
}
