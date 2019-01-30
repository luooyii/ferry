import 'package:flutter/material.dart';
import 'common/theme.dart';
import 'app/ui/login/login.dart';

void main() {
  runApp(FerryApp());
  PaintingBinding.instance.imageCache.maximumSize = 100;
}

class FerryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "chuanbo",
      theme: AppTheme.themeData,
      home: LoginPage(), //Index()
    );
  }
}
