import 'package:ferry_app/app/data/entity/sys_user.dart';
import 'package:ferry_app/app/ui/index/index.dart';
import 'package:flutter/material.dart';
import 'common/theme.dart';
import 'app/ui/login/login.dart';
import 'app/ui/index/index.dart';

void main() {
  runApp(FerryApp());
  PaintingBinding.instance.imageCache.maximumSize = 100;
}

class FerryApp extends StatelessWidget {
  //SysUser sysUser = SysUser('luooyii', '洛熠', 'luooyii@163.com', 'https://img1.doubanio.com/view/note/large/public/p225659467-7.jpg');

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "chuanbo",
      theme: AppTheme.themeData,
      home: LoginPage(), //Index(sysUser) LoginPage()
    );
  }
}
