import 'package:flutter/material.dart';

void main() {
  runApp(FerryApp());
  PaintingBinding.instance.imageCache.maximumSize = 100;
}

class FerryApp extends StatelessWidget {
  List<String> items = new List<String>.generate(1000, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text widget',
      home: Scaffold(
          body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 2.0, crossAxisSpacing: 2.0, childAspectRatio: 0.7),
        children: <Widget>[
          new Image.network('http://img5.mtime.cn/mt/2018/10/22/104316.77318635_180X260X4.jpg', fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/10/10/112514.30587089_180X260X4.jpg', fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/13/093605.61422332_180X260X4.jpg', fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/07/092515.55805319_180X260X4.jpg', fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/21/090246.16772408_135X190X4.jpg', fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/17/162028.94879602_135X190X4.jpg', fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/19/165350.52237320_135X190X4.jpg', fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/16/115256.24365160_180X260X4.jpg', fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/20/141608.71613590_135X190X4.jpg', fit: BoxFit.cover),
        ],
      )),
    );
  }
}

class MyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(children: <Widget>[
      new Image.network('http://jspang.com/static/upload/20181111/G-wj-ZQuocWlYOHM6MT2Hbh5.jpg'),
      new Image.network('http://jspang.com/static/upload/20181109/1bHNoNGpZjyriCNcvqdKo3s6.jpg'),
      new ListTile(leading: new Icon(Icons.access_time), title: new Text('lalala')),
      new ListTile(leading: new Icon(Icons.account_balance), title: new Text('account_balance')),
    ]);
  }
}
