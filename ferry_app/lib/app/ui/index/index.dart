import 'dart:collection';

import 'package:ferry_app/app/bloc/ship_console_bloc.dart';
import 'package:ferry_app/app/data/entity/sys_user.dart';
import 'package:flutter/material.dart';
import '../../../common/theme.dart';
import '../../../common/const.dart';
import 'navigation_icon_view.dart';
import '../ship_console/ship_console.dart';
import '../user_center/user_center.dart';

class Index extends StatefulWidget {
  //final LinkedHashMap userInfo;
  final SysUser sysUser;
  Index(this.sysUser);
  @override
  State<Index> createState() => _IndexState(sysUser);
}

class _IndexState extends State<Index> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final _scaffoldkey = new GlobalKey<ScaffoldState>();
  final SysUser sysUser;
  List<NavigationIconView> _navigationViews; //底部导航栏中的内容
  List<Widget> _pages; //底部导航栏指向的页面
  Widget _currentPage;
  _IndexState(this.sysUser);

  final ShipConsoleBloc shipConsoleBloc = ShipConsoleBloc.getInstance();

  @override
  void initState() {
    super.initState();
    shipConsoleBloc.snackMsgStream
        .listen((String snackMsg) => showSnackBar(snackMsg, 1));
    debugPrint('啦啦啦');

    //初始化底部导航栏里的内容
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: IconData(
          0xe620,
          fontFamily: Constants.IconFontFamily,
        ),
        title: "监视器",
        vsync: this,
      ),
      new NavigationIconView(
        icon: IconData(
          0xe75f,
          fontFamily: Constants.IconFontFamily,
        ),
        title: "我",
        vsync: this,
      ),
    ];
    //初始化页面
    _pages = [
      ShipConsole(sysUser),
      UserCenter(sysUser),
    ];
    _currentPage = _pages[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    //初始化底部导航栏
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
        items: _navigationViews
            .map((NavigationIconView navigationIconView) =>
                navigationIconView.item)
            .toList(),
        currentIndex: _currentIndex,
        //backgroundColor: AppTheme.primaryColor,
        fixedColor: AppTheme.primaryColor,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _navigationViews[_currentIndex].controller.reverse();
            _currentIndex = index;
            _navigationViews[_currentIndex].controller.forward();
            _currentPage = _pages[_currentIndex];
          });
        });

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
          home: Scaffold(
            key: _scaffoldkey,            
            body: Center(child: _currentPage),
            bottomNavigationBar: bottomNavigationBar,
          ),
          theme: AppTheme.themeData),
    );
  }

  @override
  void dispose() {
    shipConsoleBloc.dispose();
    for (NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
    super.dispose();
  }

  int _lastClickTime = 0;
  Future<bool> _onWillPop() {
    showSnackBar("再按一次返回键退出Ferry", 2);

    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      //退出
      return new Future.value(true);
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      return new Future.value(false);
    }
  }

  void showSnackBar(String message, int durationSecond) {
    final snackBar = new SnackBar(
      content: new Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: Color(0x5f009688),
      duration: Duration(seconds: durationSecond), // 持续时间
    );
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}
