import 'package:flutter/material.dart';
import 'package:frontend/screens/manga/mangaWrapper.dart';
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
                    context, contexedRoute(context, Recommend())))),
        BottomNavigationBarItem(
            label: 'Search',
            icon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => Navigator.push(
                    context, contexedRoute(context, MangaWrapper())))),
        BottomNavigationBarItem(
            label: 'Logout',
            icon: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/', (_) => false)))
      ]);

  //userInfo.updateChild(userInfo, MangaViewer(mangaSelected))
}
