import 'package:flutter/material.dart';
import 'ui/index/index.dart';
import 'common/constants/color.dart';

void main() {
  runApp(FerryApp());
  PaintingBinding.instance.imageCache.maximumSize = 100;
}

class FerryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "chuanbo",
      theme: ThemeData.light().copyWith(
        primaryColor: Color(AppColors.AppBarColor),
        cardColor: Color(AppColors.AppBarColor)
      ),
      home: Index(),
    );
  }
}
