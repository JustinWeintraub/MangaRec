import 'package:flutter/material.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/screens/recommend.dart';
import 'package:frontend/shared/contexedRoute.dart';

Widget bottomBar(context) {
  return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.black87,
      items: [
        BottomNavigationBarItem(
            label: 'Profile',
            icon: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () => Navigator.push(
                    context, contexedRoute(context, Profile())))),
        BottomNavigationBarItem(
            label: 'Recommend',
            icon: IconButton(
                icon: Icon(Icons.list),
                onPressed: () => Navigator.push(
                    context, contexedRoute(context, Recommend()))))
      ]);

  //userInfo.updateChild(userInfo, MangaViewer(mangaSelected))
}
