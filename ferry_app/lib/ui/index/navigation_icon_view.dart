import 'package:flutter/material.dart';

class NavigationIconView {
  final BottomNavigationBarItem item;
  final AnimationController controller;

  NavigationIconView({Key key, String title, IconData icon, IconData activeIcon, TickerProvider vsync})
      : item = BottomNavigationBarItem(
          icon: Icon(icon),
          title: Text(title),
        ),
        controller = AnimationController(
            duration: kThemeAnimationDuration, vsync: vsync);
}
