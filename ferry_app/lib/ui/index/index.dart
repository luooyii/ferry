import 'package:flutter/material.dart';
import '../../common/config/global_config.dart';
import '../../common/constants/constants.dart';
import 'navigation_icon_view.dart';
import '../ship_monitor/ship_monitor.dart';

class Index extends StatefulWidget {
  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;//底部导航栏中的内容
  List<Widget> _pages;//底部导航栏指向的页面
  Widget _currentPage;

  @override
  void initState() {
    super.initState();
    //初始化底部导航栏里的内容
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: IconData(
          0xe620,
          fontFamily: "iconfont",
        ),
        title: "new Text",
        vsync: this,
      ),
      new NavigationIconView(
        icon: IconData(
          0xe78c,
          fontFamily: Constants.IconFontFamily,
        ),
        title: "lll",
        vsync: this,
      ),
    ];
    //初始化页面
    _pages = [
      ShipMonitor(),
      Container(color: Colors.brown),
    ];
    _currentPage = _pages[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    //初始化底部导航栏
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
        items: _navigationViews
            .map((NavigationIconView navigationIconView) => navigationIconView.item)
            .toList(),
      currentIndex: _currentIndex,
      fixedColor: Colors.blue,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState((){
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
          _currentPage = _pages[_currentIndex];
        });
      }
    );

    return MaterialApp(
      home: new Scaffold(
        body: new Center(
            child: _currentPage
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
      theme: GlobalConfig.themeData
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
  }
}
