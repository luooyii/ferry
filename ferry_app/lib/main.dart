import 'package:flutter/material.dart';
import 'ui/index/index.dart';
import 'common/config/global_config.dart';

void main() {
  runApp(FerryApp());
  PaintingBinding.instance.imageCache.maximumSize = 100;
}

class FerryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "chuanbo",
      theme: GlobalConfig.themeData,
      home: Index(),
    );
  }
}
